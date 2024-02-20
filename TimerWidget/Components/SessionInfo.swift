//
//  SessionInfo.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 29.11.2023.
//

import SwiftUI

struct SessionInfo: View {
    let date: Date;
    let name: String;
    let sessionLengths: [String: Int];
    
    var body: some View {
        let sessionLength = Double(sessionLengths[name] ?? Int(60.0));
        
        VStack(alignment: .leading) {
            HStack {
                Text(getDayName(date: date))
                    .font(.subheadline)
                    .foregroundStyle(.red)
                
                Spacer()
                
                Text(parseSessionName(sessionName: name))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Text(date, style: .date)
                    .font(.subheadline)
                
                Spacer()
                
                Text(DateInterval(start: date, end: date.addingTimeInterval(60 * sessionLength)))
                    .font(.subheadline)
            }
        }
        .frame(
          minWidth: 0,
          maxWidth: .infinity,
          minHeight: 0,
          maxHeight: .infinity
        )
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.tertiary.opacity(0.5).shadow(.drop(color: .primary, radius: 5)))
        )
    }
}

#Preview {
    SessionInfo(date: ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!, name: parseSessionName(sessionName: RaceData().sessions.first!.key), sessionLengths: DataConfig().sessionLengths)
}
