//
//  SheetContent.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 21.12.2023.
//

import SwiftUI

struct SheetContent: View {
    let race: RaceData;
    let series: String;
    
    @Binding var isShowingRaceSheet: Bool;
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(race.futureSessions, id:\.key) { session in
                    let sessionData = SessionData(formattedName: session.value.formattedName, startDate: session.value.startDate, endDate: session.value.endDate)

                    SessionDetails(race: race, series: series, session: sessionData)
                }
            }
            .navigationTitle(getRaceTitle(race: race))
            .toolbar {
                ToolbarItem {
                    Button {
                        isShowingRaceSheet.toggle();
                    } label: {
                        Label("Close", systemImage: "xmark.circle.fill")
                    }
                    .tint(.secondary)
                }
            }
        }
    }
}

#Preview {
    SheetContent(race: RaceData(), series: "f1", isShowingRaceSheet: .constant(false))
}
