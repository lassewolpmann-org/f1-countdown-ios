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
    let dividerPadding: CGFloat;
    let sessionLengths: [String: Int];
    
    var body: some View {
        let startTime = getTime(date: date);
        let sessionLength = Double(sessionLengths[name] ?? Int(60.0));
        let endTime = getTime(date: date.addingTimeInterval(60 * sessionLength));
        
        Divider()
            .padding([.top, .bottom], dividerPadding)
        
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
                Text(getDate(date: date))
                    .font(.subheadline)
                
                Spacer()
                
                Text("from \(startTime) to \(endTime)")
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    SessionInfo(date: ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!, name: parseSessionName(sessionName: RaceData().sessions.first!.key), dividerPadding: 10.0, sessionLengths: APIConfig().sessionLengths)
}
