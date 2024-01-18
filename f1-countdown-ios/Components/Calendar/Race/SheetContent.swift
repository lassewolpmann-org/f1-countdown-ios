//
//  SheetContent.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 21.12.2023.
//

import SwiftUI

struct SheetContent: View {
    let race: RaceData;
    let config: APIConfig;
    let flag: String;
    @Binding var isShowingRaceSheet: Bool;
    
    var body: some View {
        NavigationStack {
            let sessions = race.sessions.sorted(by:{$0.value < $1.value});
            let futureSessions = sessions.filter { (key: String, value: String) in
                let date = ISO8601DateFormatter().date(from: value)!;
                
                return date.timeIntervalSinceNow > 0
            }
            
            VStack(alignment: .leading) {
                List {
                    ForEach(futureSessions, id:\.key) { session in
                        let name = session.key;
                        let parsedName = parseSessionName(sessionName: session.key);
                        let date = ISO8601DateFormatter().date(from: session.value)!;
                        
                        SessionDetails(race: race, name: name, parsedName: parsedName, date: date, config: config)
                    }
                }
            }
            .navigationTitle("\(flag) \(getRaceTitle(race: race))")
            .toolbar {
                ToolbarItem {
                    Button {
                        isShowingRaceSheet.toggle();
                    } label: {
                        Label("Close", systemImage: "xmark.circle.fill")
                    }
                    .tint(.secondary)
                }
            }
        }
    }
}

#Preview {
    SheetContent(race: RaceData(), config: APIConfig(), flag: "🇫🇮", isShowingRaceSheet: .constant(false))
}
