//
//  RaceNavigationLink.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 27.11.2023.
//

import SwiftUI

struct RaceSheet: View {
    let race: RaceData;
    let series: String;
    
    @State private var isShowingRaceSheet = false;
    @Environment(\.dismissSearch) private var dismissSearch
    
    var body: some View {
        Button {
            dismissSearch()
            isShowingRaceSheet.toggle();
        } label: {
            HStack {
                Text(getRaceTitle(race: race))
                Spacer()
                Text(race.tbc == true ? "TBC" : "")
            }
        }
        .sheet(isPresented: $isShowingRaceSheet, content: {
            SheetContent(race: race, series: series)
        })
    }
}

#Preview {
    List {
        RaceSheet(race: RaceData(), series: "f1")
    }
}
