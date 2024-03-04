//
//  SessionsTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct TimerTab: View {
    @State var nextRace: RaceData;
    @State var series: String = "f1";

    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(nextRace.futureSessions, id: \.key) { key, value in
                    Session(nextRace: $nextRace, sessionName: key, sessionDate: value, delta: deltaValues(dateString: value))
                }
            }
            .navigationTitle(getRaceTitle(race: nextRace))
        }
        .onAppear {
            series = UserDefaults.standard.string(forKey: "Series") ?? "f1";
        }
        .onChange(of: series, { oldValue, newValue in
            Task {
                do {
                    nextRace = try await AppData(series: newValue).nextRace;
                } catch {
                    print("Error getting next Race")
                }
            }
        })
        .refreshable {
            do {
                nextRace = try await AppData(series: series).nextRace;
            } catch {
                print("Error getting next Race")
            }
        }
    }
}

#Preview {
    TimerTab(nextRace: RaceData())
}
