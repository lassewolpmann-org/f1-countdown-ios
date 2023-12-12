//
//  RaceNavigationLink.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 27.11.2023.
//

import SwiftUI

struct RaceSheet: View {
    let race: RaceData;
    let config: APIConfig;
    
    @State private var isShowingRaceSheet = false;
    
    var body: some View {
        let flag = CountryFlags().flags[race.localeKey] ?? "";
        
        Button {
            isShowingRaceSheet.toggle();
        } label: {
            Label {
                Text(getRaceTitle(race: race))
            } icon: {
                Text(flag)
            }
        }
        .sheet(isPresented: $isShowingRaceSheet, content: {
            NavigationStack {
                let sessions = race.sessions.sorted(by:{$0.value < $1.value});
                
                VStack(alignment: .leading) {
                    List {
                        ForEach(sessions, id:\.key) { session in
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
                        Button(role: .cancel) {
                            isShowingRaceSheet.toggle();
                        } label: {
                            Label("Close", systemImage: "xmark.circle.fill")
                        }
                        .tint(.secondary)
                    }
                }
            }
        })
    }
}

#Preview {
    List {
        RaceSheet(race: RaceData(), config: APIConfig())
    }
}
