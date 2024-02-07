//
//  RaceNavigationLink.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 27.11.2023.
//

import SwiftUI

struct RaceSheet: View {
    let race: RaceData;
    let config: DataConfig;
    
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
            SheetContent(race: race, config: config, isShowingRaceSheet: $isShowingRaceSheet)
        })
    }
}

#Preview {
    List {
        RaceSheet(race: RaceData(), config: DataConfig())
    }
}
