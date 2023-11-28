//
//  FirstSession.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 28.11.2023.
//

import SwiftUI

struct FirstSession: View {
    let race: RaceData;
    let flags: [String: String];
    
    var body: some View {
        let session = getFirstSession(race: race);
        let name = parseSessionName(sessionName: session.key);
        let date = ISO8601DateFormatter().date(from: session.value)!;
        
        SessionDetails(race: race, flags: flags, name: name, date: date)
    }
}

#Preview {
    FirstSession(race: RaceData(), flags: [:])
}
