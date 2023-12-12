//
//  ContentView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    let nextRaces: [RaceData];
    let config: APIConfig;
    
    @State var selectedSession: String = "gp";
    
    var body: some View {
        let nextRace = nextRaces.first;
        let raceTitle = getRaceTitle(race: nextRace);
        let flag = CountryFlags().flags[nextRace?.localeKey ?? ""] ?? "";
        
        NavigationStack {
            List {
                Section {
                    SessionTimer(nextRaces: nextRaces)
                }
                .navigationTitle("\(flag) \(raceTitle)")
                .toolbar {
                    ToolbarItem {
                        InformationLink()
                    }
                }
                
                Section {
                    ForEach(nextRaces) { race in
                        RaceSheet(race: race, config: config);
                    }
                } header: {
                    Text("Upcoming Grands Prix")
                } footer: {
                    VStack(alignment: .leading) {
                        Text("This app is unofficial and is not associated in any way with the Formula 1 companies.")
                        Spacer()
                        Text("F1, FORMULA ONE, FORMULA 1, FIA FORMULA ONE WORLD CHAMPIONSHIP, GRAND PRIX and related marks are trade marks of Formula One Licensing B.V.")
                    }.padding(.top, 20)
                }
            }
        }
    }
}

#Preview {
    ContentView(nextRaces: [RaceData()], config: APIConfig())
}
