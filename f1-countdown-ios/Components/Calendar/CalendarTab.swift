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
        let calendar = Calendar.current;
        let date = ISO8601DateFormatter().date(from: appData.nextRaces.first!.sessions.first!.value)!;
        let dateComponents = calendar.dateComponents([.year], from: date);
        let year = dateComponents.year!.description;
        
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
