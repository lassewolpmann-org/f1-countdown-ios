//
//  CalendarTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.12.2023.
//

import SwiftUI

struct CalendarTab: View {
    var appData: AppData;
    @State private var searchText = "";

    var body: some View {
        let calendar = Calendar.current;
        let year = calendar.dateComponents([.year], from: Date()).year!.description;

        NavigationStack {
            List(filterRaces(), id: \.self) { race in
                RaceSheet(race: race, series: appData.series)
            }
            .navigationTitle("\(year) \(appData.series.uppercased()) Calendar")
        }
        .searchable(text: $searchText)
        .refreshable {
            do {
                appData.races = try await appData.getAllRaces()
            } catch {
                print(error)
            }
        }
    }
    
    func filterRaces() -> [RaceData] {
        let nextRaces = appData.nextRaces.filter { race in
            // Return all races if no input is given
            if (searchText == "") { return true }
            
            let raceName = race.name.lowercased()
            let locationName = race.location.lowercased()
            let input = searchText.lowercased()
            
            return raceName.contains(input) || locationName.contains(input)
        }
        
        return nextRaces
    }
}

#Preview {
    CalendarTab(appData: AppData())
}
