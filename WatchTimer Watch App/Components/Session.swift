//
//  Session.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 17.4.2024.
//

import SwiftUI

struct Session: View {
    var appData: AppData
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let nextRace: RaceData
    let session: SessionData
    let name: String
    
    @State var delta: DeltaValues
    @State var showWeatherSheet: Bool = false
    @State var showInfoSheet: Bool = false
    
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
                        Text("\(nextRace.flag) \(name)")
                            .font(.headline)
                        
                        Text(session.startDate, style: .timer)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                )
            
            HStack {
                // WeatherButton(showWeatherSheet: $showWeatherSheet)
                Spacer()
                InfoButton(showInfoSheet: $showInfoSheet)
            }
        }
        /*
        .sheet(isPresented: $showWeatherSheet, content: {
            ScrollView {
                SessionWeather(race: nextRace, series: appData.series, session: session)
                    .labelStyle(.iconOnly)
            }
        })
         */
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
                    Text(nextRace.location)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(10)
        })
        .onReceive(timer) { _ in
            let date = Date()
            
            if (date >= session.endDate) {
                // If end date is reached, set delta to 0
                delta = DeltaValues(date: date)
            } else if (date > session.startDate && date < session.endDate) {
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
                        appData.races = try await appData.getAllRaces()
                    } catch {
                        print("\(error), while updating appData in Session")
                    }
                }
            }
        }
    }
}

#Preview {
    TabView {
        let session = SessionData()
        
        Session(appData: AppData(), nextRace: RaceData(), session: session, name: parseShortSessionName(sessionName: "fp1"), delta: session.delta)
    }
    .tabViewStyle(.verticalPage)
}
