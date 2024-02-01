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
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
    let name: String;
    let date: String;
        
    var body: some View {
        VStack(alignment: .leading) {
            Text(parseSessionName(sessionName: name))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .bold()
                .padding(.leading, 10)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemFill))
                    .stroke(.secondary, lineWidth: 1)
                    
                VStack {
                    HStack {
                        TimerElement(delta: delta.days, deltaPct: delta.daysPct, ringColor: Color.primary, timeUnit: "days")
                        TimerElement(delta: delta.hours, deltaPct: delta.hoursPct, ringColor: Color.red, timeUnit: "hr")
                        TimerElement(delta: delta.minutes, deltaPct: delta.minutesPct, ringColor: Color.green, timeUnit: "min")
                        TimerElement(delta: delta.seconds, deltaPct: delta.secondsPct, ringColor: Color.blue, timeUnit: "sec")
                        
                        Divider()
                        
                        NotificationButton(raceName: name, sessionName: name, sessionDate: ISO8601DateFormatter().date(from: date)!)
                    }
                    .padding(5)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            }
        }
        .padding(10)
        .onReceive(timer) { _ in
            delta = deltaValues(dateString: date);
        }
    }
}

#Preview {
    ScrollView {
        let firstSession = RaceData().sessions.first!;
        Session(delta: deltaValues(dateString: firstSession.value), name: firstSession.key, date: firstSession.value)
        Session(delta: deltaValues(dateString: firstSession.value), name: firstSession.key, date: firstSession.value)
    }
}
