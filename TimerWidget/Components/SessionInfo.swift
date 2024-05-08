//
//  SessionInfo.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 29.11.2023.
//

import SwiftUI
import WidgetKit

struct SessionInfo: View {
    let date: Date;
    let name: String;
    let sessionLengths: [String: [String: Double]];
    
    var body: some View {
        let sessionLength = sessionLengths["f1"]?[name] ?? 60;
        
        VStack(alignment: .leading) {
            HStack {
                Text(parseSessionName(sessionName: name))
                    .foregroundStyle(.red)
                
                Spacer()
                
                Text(getDayName(date: date))
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                if (date.timeIntervalSinceNow <= 0) {
                    Label("Finished", systemImage: "flag.checkered")
                } else if (date.timeIntervalSinceNow <= 60 * 60) {
                    Text("Session starts in \(timerInterval: Date.now...date, pauseTime: Date.now)")
                } else {
                    Text(date, style: .date)
                    
                    Spacer()
                    
                    Text(DateInterval(start: date, end: date.addingTimeInterval(60 * sessionLength)))
                }
            }
        }
        .font(.subheadline)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview(as: .systemLarge) {
    TimerWidget()
} timeline: {
    TimerEntry(race: RaceData(), tbc: false, flag: "", sessionLengths: RaceData().sessionLengths)
}
