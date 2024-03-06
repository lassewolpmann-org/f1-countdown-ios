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
    
    var body: some View {
        Button {
            isShowingRaceSheet.toggle();
        } label: {
            HStack {
                Text(getRaceTitle(race: race))
                Spacer()
                Text(race.tbc == true ? "TBC" : "")
            }
        }
        .sheet(isPresented: $isShowingRaceSheet, content: {
            SheetContent(race: race, series: series, isShowingRaceSheet: $isShowingRaceSheet)
        })
    }
}

#Preview {
    List {
        RaceSheet(race: RaceData(), series: "f1")
    }
}
