//
//  Session.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct Session: View {
    var appData: AppData
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let nextRace: RaceData
    let session: SessionData
    
    @State var delta: DeltaValues
    @State var showWeather: Bool = false
        
    var body: some View {
        VStack {
            HStack {
                Text(session.formattedName)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            
            HStack {
                TimerElement(delta: delta.days, deltaPct: delta.daysPct, ringColor: Color.primary, timeUnit: "days")
                TimerElement(delta: delta.hours, deltaPct: delta.hoursPct, ringColor: Color.red, timeUnit: "hr")
                TimerElement(delta: delta.minutes, deltaPct: delta.minutesPct, ringColor: Color.green, timeUnit: "min")
                TimerElement(delta: delta.seconds, deltaPct: delta.secondsPct, ringColor: Color.blue, timeUnit: "sec")
                
                Divider()
                
                VStack {
                    NotificationButton(session: session, race: nextRace, series: appData.series)
                    
                    Button {
                        showWeather.toggle()
                    } label: {
                        Label("Weather Forecast", systemImage: "cloud")
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .sheet(isPresented: $showWeather, content: {
            SessionWeather(race: nextRace, series: appData.series, session: session)
                .presentationDetents([.medium])
                .presentationBackground(.regularMaterial)
        })
        .padding(10)
        .background(.ultraThinMaterial, in:
            RoundedRectangle(cornerRadius: 10)
        )
        .onReceive(timer) { _ in
            if (Date() > session.startDate) {
                delta = DeltaValues(date: session.endDate)
            } else {
                delta = DeltaValues(date: session.startDate)
            }
            
            let startDate = Int(session.startDate.timeIntervalSince1970)
            let endDate = Int(session.endDate.timeIntervalSince1970)
            let currentDate = Int(Date().timeIntervalSince1970)
            
            if (startDate == currentDate || endDate == currentDate) {
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
    ScrollView {        
        Session(appData: AppData(), nextRace: RaceData(), session: SessionData(), delta: DeltaValues(date: Date()))
    }
}
