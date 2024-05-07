//
//  Session.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct Session: View {
    @Environment(AppData.self) private var appData;
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
    let sessionName: String;
    let sessionDate: String;
    
    @State var delta: deltaValues;
        
    var body: some View {
        VStack(alignment: .leading) {
            Text(parseSessionName(sessionName: sessionName))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .bold()
            
            VStack {
                HStack {
                    TimerElement(delta: delta.days, deltaPct: delta.daysPct, ringColor: Color.primary, timeUnit: "days")
                    TimerElement(delta: delta.hours, deltaPct: delta.hoursPct, ringColor: Color.red, timeUnit: "hr")
                    TimerElement(delta: delta.minutes, deltaPct: delta.minutesPct, ringColor: Color.green, timeUnit: "min")
                    TimerElement(delta: delta.seconds, deltaPct: delta.secondsPct, ringColor: Color.blue, timeUnit: "sec")
                    
                    Divider()
                                    
                    NotificationButton(sessionName: sessionName, sessionDate: sessionDate, race: appData.nextRace, series: appData.series)
                }
                .padding(10)
                
                SessionWeather(nextRace: appData.nextRace, series: appData.series, sessionDate: sessionDate, sessionName: sessionName)
            }
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(.tertiary.opacity(0.5).shadow(.drop(color: .primary, radius: 5)))
            )
        }
        .onAppear {
            // print(displayScale, horizontalSizeClass, verticalSizeClass)
        }
        .padding(10)
        .onReceive(timer) { _ in
            delta = deltaValues(dateString: sessionDate);
            
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

#Preview {
    ScrollView {
        let nextRace = RaceData();
        let firstSession = nextRace.futureSessions.first!;
        
        Session(sessionName: firstSession.key, sessionDate: firstSession.value, delta: deltaValues(dateString: Date().ISO8601Format()))
            .environment(AppData(series: "f1"))
    }
}
