//
//  SessionsTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct TimerTabView: View {
    let seriesRaces: [RaceData]
    @State var currentDate: Date = .now
    @State private var pickedSeries: [String] = []
    
    var nextRace: RaceData? {
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: .now)
        let currentSeries = seriesRaces.filter { $0.series == selectedSeries }
        let currentSeason = currentSeries.filter { $0.season == currentYear }
        let futureRaces = currentSeason.filter { $0.endDate > currentDate }
        let sortedRaces = futureRaces.sorted { $0.startDate < $1.startDate }
        
        return sortedRaces.first
    }
    
    @Binding var selectedSeries: String
    let notificationController: NotificationController
    
    var body: some View {
        NavigationStack {
            List {
                SeriesPickerView(selectedSeries: $selectedSeries)
                
                if let nextRace {
                    ForEach(nextRace.race.sessions, id: \.startDate) { session in
                        Section {
                            SessionView(nextRace: nextRace, session: session, currentDate: currentDate, notificationController: notificationController)
                        }
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.regularMaterial)
                    )
                } else {
                    Label {
                        Text("It seems like there is no data available to display here.")
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                    }
                    .symbolRenderingMode(.multicolor)
                }
            }
            .listSectionSpacing(10)
            .navigationTitle(nextRace?.race.title ?? "No data available.")
            .scrollContentBackground(.hidden)
            .background(FlagBackgroundView(flag: nextRace?.race.flag ?? ""))
        }
        .onAppear {
            guard let nextRace else { return }
            
            for session in nextRace.race.sessions {
                DispatchQueue.main.asyncAfter(deadline: .now() + session.startDate.timeIntervalSinceNow) {
                    currentDate = Date()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + session.endDate.timeIntervalSinceNow) {
                    currentDate = Date()
                }
            }
        }
        .refreshable {
            currentDate = Date()
        }
    }
    
    struct SeriesPickerView: View {
        @Binding var selectedSeries: String

        var body: some View {
            Section {
                Picker(selection: $selectedSeries) {
                    ForEach(availableSeries, id: \.self) { series in
                        Text(series.uppercased())
                    }
                } label: {
                    Text("Select Series")
                }
                .sensoryFeedback(.selection, trigger: selectedSeries)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThickMaterial)
                )
            }
        }
    }
    
    struct SessionView: View {
        @State private var collapsedView: Bool = false
        
        let nextRace: RaceData
        let session: Season.Race.Session
        let currentDate: Date
        let notificationController: NotificationController
        
        var sessionStatus: Season.Race.Session.Status {
            if (currentDate >= session.endDate) {
                return .finished
            } else if (currentDate >= session.startDate && currentDate < session.endDate) {
                return .ongoing
            } else {
                return .upcoming
            }
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: collapsedView ? "plus" : "minus")
                        .foregroundStyle(.selection)
                    
                    Text(session.longName)
                        .font(.headline)
                        .foregroundStyle(.red)
                    
                    Spacer()
                    
                    HStack {
                        Text(sessionStatus.rawValue)
                        
                        switch sessionStatus {
                        case .finished:
                            Image(systemName: "flag.checkered.2.crossed")
                        case .ongoing:
                            Image(systemName: "flag.checkered")
                        case .upcoming:
                            Image(systemName: "clock")
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                
                if (!collapsedView) {
                    HStack {
                        VStack(alignment: .leading) {
                            Label {
                                Text("\(session.dayString), \(session.dateString)")
                            } icon: {
                                Image(systemName: "calendar").padding(.vertical, 5)
                            }
                            
                            Label {
                                Text(DateInterval(start: session.startDate, end: session.endDate))
                            } icon: {
                                Image(systemName: "clock").padding(.vertical, 5)
                            }
                        }
                        
                        Spacer()
                        
                        NotificationButton(session: session, sessionStatus: sessionStatus, race: nextRace, notificationController: notificationController)
                    }
                    .font(.body)
                    
                    if (sessionStatus == .upcoming) {
                        Text("Session starts in \(session.startDate, style: .relative)").font(.callout)
                    } else if (sessionStatus == .ongoing) {
                        Text("Session ends in \(session.endDate, style: .relative)").font(.callout)
                    } else {
                        Text("Session has ended.").font(.callout)
                    }
                }
            }
            .sensoryFeedback(.selection, trigger: collapsedView)
            .onTapGesture {
                collapsedView.toggle()
            }
            .onAppear {
                collapsedView = sessionStatus == .finished
            }
        }
    }

    struct FlagBackgroundView: View {
        let flag: String
        
        var body: some View {
            GeometryReader { geo in
                Text(flag)
                    .font(.system(size: 1000))
                    .minimumScaleFactor(0.005)
                    .lineLimit(1)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .rotationEffect(.degrees(90))
                    .blur(radius: 50)
            }
        }
    }
}

#Preview {
    TimerTabView(seriesRaces: sampleRaces, selectedSeries: .constant("f1"), notificationController: NotificationController())
}
