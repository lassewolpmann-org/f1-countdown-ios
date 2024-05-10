//
//  CalendarTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.12.2023.
//

import SwiftUI

struct CalendarTab: View {
    @Environment(AppData.self) private var appData;
    @State private var searchText = "";

    var body: some View {
        let formatter = ISO8601DateFormatter();
        let calendar = Calendar.current;
        let year = calendar.dateComponents([.year], from: Date()).year!.description;

        NavigationStack {
            List {
                ForEach(appData.nextRaces.filter({ race in
                    if (searchText == "") { return true }
                    
                    let raceName = race.name.lowercased()
                    let locationName = race.location.lowercased()
                    let input = searchText.lowercased()
                    
                    return raceName.contains(input) || locationName.contains(input)
                })) { race in
                    RaceSheet(race: race, series: appData.series);
                }
            }
            .navigationTitle("\(year) \(appData.series.uppercased()) Calendar")
        }
        .searchable(text: $searchText)
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
