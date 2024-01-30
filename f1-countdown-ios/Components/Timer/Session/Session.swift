//
//  Session.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct Session: View {
    @State var delta = deltaValues(dateString: RaceData().sessions.first!.value);
    @Environment(\.colorScheme) private var colorScheme;
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
    let name: String;
    let date: String;
        
    var body: some View {
        Section {
            HStack {
                TimerElement(delta: delta.days, deltaPct: delta.daysPct, ringColor: Color.primary, timeUnit: "days")
                TimerElement(delta: delta.hours, deltaPct: delta.hoursPct, ringColor: Color.red, timeUnit: "hr")
                TimerElement(delta: delta.minutes, deltaPct: delta.minutesPct, ringColor: Color.green, timeUnit: "min")
                TimerElement(delta: delta.seconds, deltaPct: delta.secondsPct, ringColor: Color.blue, timeUnit: "sec")
            }
        } header: {
            Text(parseSessionName(sessionName: name))
        }
        .onReceive(timer) { _ in
            delta = deltaValues(dateString: date);
        }
    }
}

#Preview {
    List {
        Session(name: RaceData().sessions.first!.key, date: RaceData().sessions.first!.value)
        Session(name: RaceData().sessions.first!.key, date: RaceData().sessions.first!.value)
    }
}
