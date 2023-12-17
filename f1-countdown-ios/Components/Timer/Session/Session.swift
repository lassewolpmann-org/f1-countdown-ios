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
        let firstRingColor = colorScheme == .dark ? Color(red: 0.85, green: 0.85, blue: 0.85) : Color(red: 0.15, green: 0.15, blue: 0.15);
        let secondRingColor = colorScheme == .dark ? Color.red : Color(red: 0.85, green: 0, blue: 0);
        let thirdRingColor = colorScheme == .dark ? Color.green : Color(red: 0, green: 0.5, blue: 0);
        let fourthRingColor = colorScheme == .dark ? Color.blue : Color(red: 0, green: 0, blue: 1);
        
        Section {
            HStack {
                TimerElement(delta: delta.days, deltaPct: delta.daysPct, ringColor: firstRingColor, timeUnit: "days")
                TimerElement(delta: delta.hours, deltaPct: delta.hoursPct, ringColor: secondRingColor, timeUnit: "hr")
                TimerElement(delta: delta.minutes, deltaPct: delta.minutesPct, ringColor: thirdRingColor, timeUnit: "min")
                TimerElement(delta: delta.seconds, deltaPct: delta.secondsPct, ringColor: fourthRingColor, timeUnit: "sec")
            }
        } header: {
            Text(parseSessionName(sessionName: name))
        }.onReceive(timer) { _ in
            delta = deltaValues(dateString: date);
        }
    }
}

#Preview {
    List {
        Session(name: RaceData().sessions.first!.key, date: RaceData().sessions.first!.value)
    }
}
