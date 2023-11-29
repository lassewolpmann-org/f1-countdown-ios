//
//  RaceNavigationLink.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 27.11.2023.
//

import SwiftUI

struct RaceNavigationLink: View {
    let race: RaceData;
    let flags: [String: String];
    let config: APIConfig;
    
    var body: some View {
        NavigationLink {
            RaceDetails(race: race, flags: flags, config: config)
        } label: {
            Label {
                Text(getRaceTitle(race: race))
            } icon: {
                Text(flags[race.localeKey] ?? "")
            }
        }
    }
}

#Preview {
    RaceNavigationLink(race: RaceData(), flags: [:], config: APIConfig())
}
