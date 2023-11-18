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
    
    var body: some View {
        NavigationStack {
            List {
                if (nextRaces.isEmpty) {
                    Section {
                        Text("Data loading...")
                        ProgressView()
                    }
                } else {
                    let nextRace = nextRaces.first;
                    let raceName = nextRace?.name ?? "Undefined";
                    let sessions = nextRace?.sessions ?? ["Undefined": "1970-01-01T00:00:00Z"];
                    let currentSessionDate = sessions[selectedSession];

                    Section {
                        VStack {
                            SessionPicker(selectedSession: $selectedSession, sessions: sessions)
                                .padding([.top, .bottom], 20.0)
                            
                            SessionTimer(currentSessionDate: currentSessionDate ?? "1970-01-01T00:00:00Z")
                        }
                    }
                    
                    Section {
                        ForEach(nextRaces) { race in
                            NavigationLink("\(race.name) Grand Prix") {
                                RaceDetails(race: race)
                            }
                        }
                    } header: {
                        Text("Upcoming Grands Prix")
                    }
                    .navigationTitle("\(raceName) Grand Prix")
                }
            }
            .task {
                do {
                    nextRaces = try await callAPI()
                } catch {
                    print("Error calling API")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        //.preferredColorScheme(.dark)
}
