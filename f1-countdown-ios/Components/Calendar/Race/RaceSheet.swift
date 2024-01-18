//
//  RaceNavigationLink.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 27.11.2023.
//

import SwiftUI

struct RaceSheet: View {
    let race: RaceData;
    let config: APIConfig;
    
    @State private var isShowingRaceSheet = false;
    
    var body: some View {
        let flag = CountryFlags().flags[race.localeKey] ?? "";
        
        Button {
            isShowingRaceSheet.toggle();
        } label: {
            Label {
                HStack {
                    Text(getRaceTitle(race: race))
                    Spacer()
                    Text(race.tbc == true ? "TBC" : "")
                }
            } icon: {
                Text(flag)
            }
        }
        .sheet(isPresented: $isShowingRaceSheet, content: {
            SheetContent(race: race, config: config, flag: flag, isShowingRaceSheet: $isShowingRaceSheet)
        })
    }
}

#Preview {
    List {
        RaceSheet(race: RaceData(), config: APIConfig())
    }
}
