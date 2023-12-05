//
//  RaceNavigationLink.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 27.11.2023.
//

import SwiftUI

struct RaceSheet: View {
    let race: RaceData;
    let flags: [String: String];
    let config: APIConfig;
    
    @State private var isShowingRaceSheet = false;
    
    var body: some View {
        Button {
            isShowingRaceSheet.toggle();
        } label: {
            Label {
                Text(getRaceTitle(race: race))
            } icon: {
                Text(flags[race.localeKey] ?? "")
            }
        }.sheet(isPresented: $isShowingRaceSheet, content: {
            let sessions = race.sessions.sorted(by:{$0.value < $1.value});
            
            List {
                ForEach(sessions, id:\.key) { session in
                    let name = session.key;
                    let parsedName = parseSessionName(sessionName: session.key);
                    let date = ISO8601DateFormatter().date(from: session.value)!;
                    
                    SessionDetails(race: race, flags: flags, name: name, parsedName: parsedName, date: date, config: config)
                }
            }
        })
    }
}

#Preview {
    RaceSheet(race: RaceData(), flags: [:], config: APIConfig())
}
