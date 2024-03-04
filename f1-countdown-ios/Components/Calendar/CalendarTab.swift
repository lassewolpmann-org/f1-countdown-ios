//
//  CalendarTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.12.2023.
//

import SwiftUI

struct CalendarTab: View {
    @State var nextRaces: [RaceData];
    @State var series: String = "f1";
    
    var body: some View {
        let calendar = Calendar.current;
        let date = ISO8601DateFormatter().date(from: nextRaces.first!.sessions.first!.value)!;
        let dateComponents = calendar.dateComponents([.year], from: date);
        let year = dateComponents.year!.description;
        
        NavigationStack {
            List {
                ForEach(nextRaces) { race in
                    RaceSheet(race: race);
                }
            }
            .navigationTitle("\(year) \(series.uppercased()) Calendar")
        }
        .onAppear {
            series = UserDefaults.standard.string(forKey: "Series") ?? "f1";
        }
        .onChange(of: series, { oldValue, newValue in
            Task {
                do {
                    nextRaces = try await AppData(series: newValue).nextRaces;
                } catch {
                    print("Error getting next Races")
                }
            }
        })
        .refreshable {
            do {
                nextRaces = try await AppData(series: series).nextRaces;
            } catch {
                print("Error getting next Races")
            }
        }
    }
}

#Preview {
    CalendarTab(nextRaces: [RaceData()])
}
