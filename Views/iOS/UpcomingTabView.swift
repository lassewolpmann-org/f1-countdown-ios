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
                    ForEach(appData.filteredRaces.indices, id: \.self) { currentIndex in
                        let previousRace = appData.filteredRaces[safe: currentIndex - 1]
                        let followingRace = appData.filteredRaces[safe: currentIndex + 1]
                        if let currentRace = appData.filteredRaces[safe: currentIndex] {
                            CalendarRace(race: currentRace, previousRace: previousRace, followingRace: followingRace)
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
