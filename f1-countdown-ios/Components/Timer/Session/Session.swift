//
//  Session.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct Session: View {
    let nextRace: RaceData;
    let dataConfig: DataConfig;
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
    let sessionName: String;
    let sessionDate: String;
    
    @State var showWeatherForecast: Bool = false;
    @State var delta: deltaValues = deltaValues(dateString: Date().ISO8601Format());
        
    var body: some View {
        VStack(alignment: .leading) {
            Text(parseSessionName(sessionName: sessionName))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .bold()
            
            HStack {
                TimerElement(delta: delta.days, deltaPct: delta.daysPct, ringColor: Color.primary, timeUnit: "days")
                TimerElement(delta: delta.hours, deltaPct: delta.hoursPct, ringColor: Color.red, timeUnit: "hr")
                TimerElement(delta: delta.minutes, deltaPct: delta.minutesPct, ringColor: Color.green, timeUnit: "min")
                TimerElement(delta: delta.seconds, deltaPct: delta.secondsPct, ringColor: Color.blue, timeUnit: "sec")
                
                Divider()
                
                VStack(spacing: 10) {
                    NotificationButton(sessionName: sessionName, sessionDate: ISO8601DateFormatter().date(from: sessionDate)!)
                    
                    Button {
                        showWeatherForecast.toggle()
                    } label: {
                        Label("Weather", systemImage: "cloud.sun")
                    }
                    .buttonStyle(.bordered)
                    .labelStyle(.iconOnly)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.tertiary.opacity(0.5).shadow(.drop(color: .primary, radius: 5)))
            )
        }
        .padding(10)
        .onReceive(timer) { _ in
            delta = deltaValues(dateString: sessionDate);
        }
        .sheet(isPresented: $showWeatherForecast, content: {
            let sessionDate = ISO8601DateFormatter().date(from: sessionDate)!;
            SessionWeather(race: nextRace, name: sessionName, date: sessionDate, config: dataConfig)
                .presentationDetents([.medium])
        })
    }
}

#Preview {
    ScrollView {
        let nextRace = AppData().nextRaces.first!;
        let firstSession = nextRace.sortedSessions.first!;
        
        Session(nextRace: nextRace, dataConfig: DataConfig(), sessionName: firstSession.key, sessionDate: firstSession.value)
        Session(nextRace: nextRace, dataConfig: DataConfig(), sessionName: firstSession.key, sessionDate: firstSession.value)
    }
}
