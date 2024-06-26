//
//  CalendarTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.12.2023.
//

import SwiftUI

struct CalendarTab: View {
    @Bindable var appData: AppData;

    var body: some View {
        let calendar = Calendar.current;
        let year = calendar.dateComponents([.year], from: Date()).year!.description;

        NavigationStack {
            List(appData.filteredRaces, id: \.self) { race in
                RaceSheet(race: race, series: appData.currentSeries)
            }
            .navigationTitle("\(year) \(appData.currentSeries.uppercased()) Calendar")
        }
        .searchable(text: $appData.calendarSearchFilter)
        .refreshable {
            do {
                try await appData.loadAPIData()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    CalendarTab(appData: AppData())
}
