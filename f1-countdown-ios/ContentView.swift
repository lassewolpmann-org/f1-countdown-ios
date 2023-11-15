//
//  ContentView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var nextRaces: [RaceData] = [RaceData]();
    @State var selectedSession: String = "fp1";
    
    var body: some View {
        VStack {
            if (nextRaces.isEmpty) {
                Text("Data loading...")
                ProgressView()
            } else {
                let nextRace = nextRaces.first;
                let raceName = nextRace?.name ?? "Undefined";
                let sessions = nextRace?.sessions ?? ["Undefined": "1970-01-01T00:00:00Z"];
                let sortedSessions = sessions.sorted(by:{$0.value < $1.value});
                let currentSessionDate = sessions[selectedSession]
                
                RaceTitle(raceName: raceName)
                    .padding()
                    .bold()
                    .font(.title)
                
                Picker("Session", selection: $selectedSession) {
                    ForEach(sortedSessions, id:\.key) {
                        key, value in
                        Text(key.uppercased())
                    }
                }
                .padding()
                .pickerStyle(.segmented)
                
                SessionTimer(currentSessionDate: currentSessionDate ?? "1970-01-01T00:00:00Z")
            }
        }
        .background(Color(UIColor.systemBackground))
        .task {
            do {
                nextRaces = try await callAPI()
            } catch {
                print("Error calling API")
            }
        }
    }
}

#Preview {
    ContentView()
}
