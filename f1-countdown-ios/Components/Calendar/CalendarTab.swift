//
//  CalendarTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.12.2023.
//

import SwiftUI

struct CalendarTab: View {
    @Environment(AppData.self) private var appData;

    var body: some View {
        let calendar = Calendar.current;
        let date = ISO8601DateFormatter().date(from: appData.nextRaces.first!.sessions.first!.value)!;
        let dateComponents = calendar.dateComponents([.year], from: date);
        let year = dateComponents.year!.description;
        
        NavigationStack {
            List {
                ForEach(appData.nextRaces) { race in
                    RaceSheet(race: race, series: appData.series);
                }
            }
            .navigationTitle("\(year) \(appData.series.uppercased()) Calendar")
        }
        .refreshable {
            do {
                appData.races = try await appData.getAllRaces()
            } catch {
                
            }
        }
    }
}

#Preview {
    CalendarTab()
        .environment(AppData(series: "f1"))
}
