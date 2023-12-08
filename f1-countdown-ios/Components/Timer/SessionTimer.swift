//
//  Timer.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct SessionTimer: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme
    
    let nextRaces: [RaceData];
    @State var selectedSession: String = "gp";
    
    @State var timer: Timer?;
    @State var delta = deltaValues(dateString: RaceData().sessions.first!.value);
    
    var body: some View {
        let nextRace = nextRaces.first;
        let sessions = nextRace!.sessions;
        let currentSessionDate = sessions[selectedSession]!;
        
        let firstRingColor = colorScheme == .dark ? Color(red: 0.85, green: 0.85, blue: 0.85) : Color(red: 0.15, green: 0.15, blue: 0.15);
        let secondRingColor = colorScheme == .dark ? Color.red : Color(red: 0.85, green: 0, blue: 0);
        let thirdRingColor = colorScheme == .dark ? Color.green : Color(red: 0, green: 0.5, blue: 0);
        let fourthRingColor = colorScheme == .dark ? Color.blue : Color(red: 0, green: 0, blue: 1);
        
        VStack {
            SessionPicker(selectedSession: $selectedSession, sessions: sessions)
                .padding([.top, .bottom], 20.0)
            
            Grid {
                if (UIScreen.main.bounds.width < 768) {
                    GridRow {
                        TimerElement(delta: delta.days, deltaPct: delta.daysPct, ringColor: firstRingColor, timeUnit: "days")
                        TimerElement(delta: delta.hours, deltaPct: delta.hoursPct, ringColor: secondRingColor, timeUnit: "hours")
                    }
                    
                    GridRow {
                        TimerElement(delta: delta.minutes, deltaPct: delta.minutesPct, ringColor: thirdRingColor, timeUnit: "minutes")
                        TimerElement(delta: delta.seconds, deltaPct: delta.secondsPct, ringColor: fourthRingColor, timeUnit: "seconds")
                    }
                } else {
                    GridRow {
                        TimerElement(delta: delta.days, deltaPct: delta.daysPct, ringColor: firstRingColor, timeUnit: "days")
                        TimerElement(delta: delta.hours, deltaPct: delta.hoursPct, ringColor: secondRingColor, timeUnit: "hours")
                        TimerElement(delta: delta.minutes, deltaPct: delta.minutesPct, ringColor: thirdRingColor, timeUnit: "minutes")
                        TimerElement(delta: delta.seconds, deltaPct: delta.secondsPct, ringColor: fourthRingColor, timeUnit: "seconds")
                    }
                }
            }
            .onChange(of: currentSessionDate, initial: true) {
                delta = deltaValues(dateString: currentSessionDate);
                
                timer?.invalidate();
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    delta = deltaValues(dateString: currentSessionDate);
                })
            }
            .onChange(of: scenePhase) {
                delta = deltaValues(dateString: currentSessionDate);
            }
        }
    }
}

#Preview {
    SessionTimer(nextRaces: [RaceData()], delta: deltaValues(dateString: RaceData().sessions.first!.value))
}
