//
//  SessionPicker.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.11.2023.
//

import SwiftUI

struct SessionPicker: View {
    @Binding var selectedSession: String
    var sessions: [String: String] = ["Undefined": "1970-01-01T00:00:00Z"];
    
    var body: some View {
        let sortedSessions = sessions.sorted(by:{$0.value < $1.value});
        
        Picker("Session", selection: $selectedSession) {
            ForEach(sortedSessions, id:\.key) { key, value in
                Text(key.uppercased())
            }
        }
        .pickerStyle(.segmented)
        .onAppear {
            let sortedSessions = sessions.sorted(by:{$0.value < $1.value});
            
            let futureSessions = sortedSessions.filter { (key: String, value: String) in
                let currentDate = Date();
                let sessionDate = formatDate(dateString: value);
                
                let currentTimestamp = currentDate.timeIntervalSince1970;
                let sessionTimestamp = sessionDate.timeIntervalSince1970;
                
                return currentTimestamp < sessionTimestamp
            }
            
            let firstSession = futureSessions.first?.key;
            
            selectedSession = firstSession ?? "gp";
        }
    }
}

#Preview {
    SessionPicker(selectedSession: .constant("gp"))
}
