//
//  Session.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct Session: View {
    var appData: AppData
    var userDefaults: UserDefaultsController
    var notificationController: NotificationController
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let nextRace: RaceData
    let session: SessionData
    let status: SessionStatus
    
    @State var delta: DeltaValues
    @State var showWeather: Bool = false
        
    var body: some View {
        VStack {
            HStack {
                Text(session.longName)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Label {
                    switch status {
                    case .finished:
                        Text("Finished")
                    case .ongoing:
                        Text("Ongoing")
                    case .upcoming:
                        Text("Upcoming")
                    }
                } icon: {
                    switch status {
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
            
            HStack(spacing: 5) {
                TimerElement(delta: delta.days, deltaPct: delta.daysPct, timeUnit: "days")
                Text(":")
                TimerElement(delta: delta.hours, deltaPct: delta.hoursPct, timeUnit: "hours")
                Text(":")
                TimerElement(delta: delta.minutes, deltaPct: delta.minutesPct, timeUnit: "minutes")
                Text(":")
                TimerElement(delta: delta.seconds, deltaPct: delta.secondsPct, timeUnit: "seconds")
                
                VStack {
                    NotificationButton(userDefaults: userDefaults, notificationController: notificationController, session: session, race: nextRace, series: appData.currentSeries)
                    
                    Button {
                        showWeather.toggle()
                    } label: {
                        Label("Weather Forecast", systemImage: "cloud")
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(.bordered)
                    .disabled(session.startDate < Date())
                }
                .padding(.leading, 10)
            }
        }
        .sheet(isPresented: $showWeather, content: {
            SessionWeather(race: nextRace, session: session)
                .presentationDetents([.medium])
                .presentationBackground(.regularMaterial)
        })
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial))
        .onReceive(timer) { _ in
            let date = Date()
            
            if (date >= session.endDate) {
                // If end date is reached, set delta to 0
                delta = DeltaValues(date: date)
            } else if (date > session.startDate && date < session.endDate) {
                // If session is ongoing, calculate delta to end date
                delta = DeltaValues(date: session.endDate)
            } else {
                delta = DeltaValues(date: session.startDate)
            }
                        
            let startTimestamp = Int(session.startDate.timeIntervalSince1970)
            let endTimestamp = Int(session.endDate.timeIntervalSince1970)
            let currentTimestamp = Int(date.timeIntervalSince1970)
            
            if (startTimestamp == currentTimestamp || endTimestamp == currentTimestamp) {
                Task {
                    do {
                        try await appData.loadAPIData()
                    } catch {
                        print("\(error), while updating appData in Session")
                    }
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        let session = SessionData(rawName: "undefined")
        Session(appData: AppData(), userDefaults: UserDefaultsController(), notificationController: NotificationController(), nextRace: RaceData(), session: session, status: .finished, delta: DeltaValues(date: session.startDate))
    }
}
