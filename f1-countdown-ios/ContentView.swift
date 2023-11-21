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
                    Section {
                        SessionTimer(nextRaces: nextRaces)
                    }
                    
                    Section {
                        ForEach(nextRaces) { race in
                            NavigationLink(getRaceTitle(race: race)) {
                                RaceDetails(race: race)
                            }
                        }
                    } header: {
                        Text("Upcoming Grands Prix")
                    }
                    .navigationTitle(getRaceTitle(race: nextRaces.first))
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
}
