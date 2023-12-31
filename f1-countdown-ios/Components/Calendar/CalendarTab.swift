//
//  CalendarTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.12.2023.
//

import SwiftUI

struct CalendarTab: View {
    let nextRaces: [RaceData];
    let config: APIConfig;
    
    var body: some View {
        let calendar = Calendar.current;
        let date = ISO8601DateFormatter().date(from: nextRaces.first!.sessions.first!.value)!;
        let dateComponents = calendar.dateComponents([.year], from: date);
        let year = dateComponents.year!.description;
        
        NavigationStack {
            List {
                ForEach(nextRaces) { race in
                    RaceSheet(race: race, config: config);
                }
            }.navigationTitle("\(year) Calendar")
        }
    }
}

#Preview {
    CalendarTab(nextRaces: [RaceData()], config: APIConfig())
}
