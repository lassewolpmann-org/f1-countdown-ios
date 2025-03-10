//
//  Session.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 17.4.2024.
//

import SwiftUI
import SwiftData

struct SessionTab: View {
    @State var session: Season.Race.Session
    @State var delta: DeltaValues
    @State var showInfoSheet: Bool = false
    @State var showSettingsSheet: Bool = false
    @Binding var selectedSeries: String
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let race: Season.Race
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TimerCircle(deltaPct: delta.daysPct, ringColor: .primary)
                .padding(6)
            TimerCircle(deltaPct: delta.hoursPct, ringColor: .red)
                .padding(12)
            TimerCircle(deltaPct: delta.minutesPct, ringColor: .green)
                .padding(18)
            TimerCircle(deltaPct: delta.secondsPct, ringColor: .blue)
                .padding(24)
                .background(
                    VStack {
                        Text("\(race.flag) \(session.shortName)")
                        .font(.headline)

                        Text(session.startDate, style: .timer)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    }
                )

            HStack {
                Button {
                    showSettingsSheet.toggle()
                } label: {
                    Image(systemName: "gear")
                }
                .clipShape(Circle())
                .frame(width: 20, height: 20)
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button {
                    showInfoSheet.toggle()
                } label: {
                    Image(systemName: "info.circle.fill")
                }
                .clipShape(Circle())
                .frame(width: 20, height: 20)
                .buttonStyle(.bordered)
            }
        }
        .padding(.horizontal, 5)
        .sheet(isPresented: $showInfoSheet, content: {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text("Session Date")
                        .font(.headline)
                    Text("\(session.startDate, style: .date), \(DateInterval(start: session.startDate, end: session.endDate))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Divider()

                    Text("Location")
                        .font(.headline)
                    Text(race.location)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(10)
        })
        .sheet(isPresented: $showSettingsSheet, content: {
            Picker(selection: $selectedSeries) {
                ForEach(availableSeries, id:\.self) { series in
                    Text(series.uppercased())
                }
            } label: {
                Text("Select Series")
            }
            .sensoryFeedback(.selection, trigger: selectedSeries)
            .pickerStyle(.navigationLink)
        })
    }
}

#Preview(traits: .sampleData) {
    TabView {
        if let race = sampleRaces.first?.race {
            if let session = race.sessions.first {
                let delta = DeltaValues(date: session.startDate)
                
                SessionTab(session: session, delta: delta, selectedSeries: .constant("f1"), race: race)
            }
        }
    }
    .tabViewStyle(.verticalPage)
}
