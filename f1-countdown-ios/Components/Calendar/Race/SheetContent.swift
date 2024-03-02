//
//  SheetContent.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 21.12.2023.
//

import SwiftUI

struct SheetContent: View {
    let race: RaceData;
    
    @Binding var isShowingRaceSheet: Bool;
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(race.futureSessions, id:\.key) { session in
                    let name = session.key;
                    let parsedName = parseSessionName(sessionName: session.key);
                    let date = ISO8601DateFormatter().date(from: session.value)!;
                    
                    SessionDetails(race: race, name: name, parsedName: parsedName, date: date)
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
    SheetContent(race: RaceData(), isShowingRaceSheet: .constant(false))
}
