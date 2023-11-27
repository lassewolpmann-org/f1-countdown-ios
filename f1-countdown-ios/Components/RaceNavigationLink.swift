//
//  RaceNavigationLink.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 27.11.2023.
//

import SwiftUI

struct RaceNavigationLink: View {
    let race: RaceData;
    
    var body: some View {
        NavigationLink(getRaceTitle(race: race)) {
            RaceDetails(race: race)
        }
    }
}

#Preview {
    RaceNavigationLink(race: RaceData())
}
