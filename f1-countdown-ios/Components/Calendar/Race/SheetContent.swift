//
//  SheetContent.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 21.12.2023.
//

import SwiftUI

struct SheetContent: View {
    @Environment(\.dismiss) var dismiss

    let race: RaceData;
    let series: String;
    
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
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .tint(.secondary)
                }
            }
        }
    }
}

#Preview {
    SheetContent(race: RaceData(), series: "f1")
}
