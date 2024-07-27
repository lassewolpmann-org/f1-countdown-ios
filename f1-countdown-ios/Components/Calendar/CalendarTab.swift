//
//  CalendarTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.12.2023.
//

import SwiftUI

struct CalendarTab: View {
    @Bindable var appData: AppData

    var body: some View {
        NavigationStack {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 20) {
                    ForEach(appData.filteredRaces) { race in
                        if let index = appData.filteredRaces.firstIndex(of: race) {
                            let previousIndex = appData.filteredRaces.index(before: index)
                            let followingIndex = appData.filteredRaces.index(after: index)
                            
                            let previousRace = appData.filteredRaces[safe: previousIndex]
                            let followingRace = appData.filteredRaces[safe: followingIndex]
                            
                            CalendarRace(race: race, previousRace: previousRace, followingRace: followingRace)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.5)
                                    .blur(radius: abs(phase.value))
                            }
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, 40, for: .scrollContent)
            .scrollTargetBehavior(.paging)
            .navigationTitle("Upcoming Races")
        }
        .searchable(text: $appData.calendarSearchFilter)
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else {
            return nil
        }

        return self[index]
    }

}

#Preview {
    CalendarTab(appData: AppData())
}
