//
//  Session.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 17.4.2024.
//

import SwiftUI

struct Session: View {
    var appData: AppData
    let session: SessionData
    
    @State var delta: DeltaValues;
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
    
    @State var showWeatherSheet: Bool = false;
    @State var showInfoSheet: Bool = false;
    
    var body: some View {
        if let nextRace = appData.nextRace {
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
                            Text("\(nextRace.flag) \(session.formattedName)")
                                .font(.headline)
                            
                            Text(session.startDate, style: .timer)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    )
                
                HStack {
                    WeatherButton(showWeatherSheet: $showWeatherSheet)
                    Spacer()
                    InfoButton(showInfoSheet: $showInfoSheet)
                }
            }
            .sheet(isPresented: $showWeatherSheet, content: {
                ScrollView {
                    SessionWeather(race: nextRace, series: appData.series, session: session)
                        .labelStyle(.iconOnly)
                }
            })
            .sheet(isPresented: $showInfoSheet, content: {
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
                .padding(10)
            })
            .onReceive(timer) { _ in
                delta = DeltaValues(date: session.startDate);
                
                if (delta.delta == 0) {
                    Task {
                        do {
                            appData.races = try await appData.getAllRaces();
                        } catch {
                            print("\(error), while updating appData in Session")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TabView {
        let session = SessionData()
        
        Session(appData: AppData(), session: session, delta: session.delta)
    }
    .tabViewStyle(.verticalPage)
}
