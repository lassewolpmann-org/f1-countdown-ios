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
    let sessionLengths: [String: Int];
    
    var body: some View {
        let sessionLength = Double(sessionLengths[name] ?? Int(60.0));
        
        VStack(alignment: .leading) {
            HStack {
                Text(parseSessionName(sessionName: name))
                    .foregroundStyle(.red)
                
                Spacer()
                
                Text(getDayName(date: date))
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                if (date.timeIntervalSinceNow <  60 * 60) {
                    Text("Session starts in \(date, style: .timer)")
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
                .fill(.tertiary.opacity(0.5).shadow(.drop(color: .primary, radius: 5)))
        )
    }
}

#Preview(as: .systemLarge) {
    TimerWidget()
} timeline: {
    TimerEntry(race: RaceData(), tbc: false, flag: "", sessionLengths: DataConfig().sessionLengths)
}
