//
//  ContentView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var nextRaces: [RaceData] = [RaceData]();
    @State var selectedSession: String = "gp";
    @State var validData: Bool = false;
    
    var body: some View {
        NavigationStack {
            List {
                if (nextRaces.isEmpty) {
                    Section {
                        Text("Data loading...")
                        ProgressView()
                    }
                } else {
                    if (validData) {
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
                                NavigationLink(getRaceTitle(race: race)) {
                                    RaceDetails(race: race)
                                }
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
                    } else {
                        Text("No data available.")
                    }
                }
            }
            .task {
                do {
                    let config = try await getAPIConfig();
                    
                    let date = Date();
                    let calendar = Calendar.current;
                    var year = calendar.component(.year, from:date);
                    
                    nextRaces = try await callAPI(year: year);
                    
                    if (nextRaces.isEmpty) {
                        year += 1;
                        
                        if (config.availableYears.contains(year)) {
                            nextRaces = try await callAPI(year: year);
                            validData = true;
                        } else {
                            nextRaces = [RaceData()]
                            validData = false;
                        }
                    } else {
                        validData = true;
                    }
                } catch {
                    print("Error calling API")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
