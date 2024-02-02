//
//  Session.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct Session: View {
    @State var delta: deltaValues;
    @Environment(\.colorScheme) private var colorScheme;
    
    let race: RaceData;
    let config: APIConfig;
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
    let name: String;
    let date: String;
    
    @State var showWeatherForecast: Bool = false;
        
    var body: some View {
        VStack(alignment: .leading) {
            Text(parseSessionName(sessionName: name))
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
                    NotificationButton(raceName: name, sessionName: name, sessionDate: ISO8601DateFormatter().date(from: date)!)
                    
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
            delta = deltaValues(dateString: date);
        }
        .sheet(isPresented: $showWeatherForecast, content: {
            let sessionDate = ISO8601DateFormatter().date(from: date)!;
            SessionWeather(race: race, name: name, date: sessionDate, config: config)
                .presentationDetents([.medium])
        })
    }
}

#Preview {
    ScrollView {
        let firstSession = RaceData().sessions.first!;
        
        Session(delta: deltaValues(dateString: firstSession.value), race: RaceData(), config: APIConfig(), name: firstSession.key, date: firstSession.value)
        Session(delta: deltaValues(dateString: firstSession.value), race: RaceData(), config: APIConfig(), name: firstSession.key, date: firstSession.value)
    }
}
