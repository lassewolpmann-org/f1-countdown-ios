//
//  ContentView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    let nextRaces: [RaceData];
    let flags: [String: String];
    let config: APIConfig;
    
    @State var selectedSession: String = "gp";
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    SessionTimer(nextRaces: nextRaces)
                }
                .navigationTitle(getRaceTitle(race: nextRaces.first))
                .toolbar {
                    ToolbarItem {
                        NavigationLink {
                            AppInformation()
                        } label: {
                            Label("Information", systemImage: "info.circle")
                        }
                    }
                }
                
                Section {
                    ForEach(nextRaces) { race in
                        RaceNavigationLink(race: race, flags: flags, config: config);
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
    ContentView(nextRaces: [RaceData()], flags: [:], config: APIConfig())
}
