//
//  SessionsTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct TimerTab: View {
    let appData: AppData;
    let dataConfig: DataConfig;
    
    var body: some View {
        let nextRace = appData.nextRaces.first!;
        
        NavigationStack {
            ScrollView {
                ForEach(nextRace.futureSessions, id: \.key) { key, value in
                    Session(nextRace: nextRace, dataConfig: dataConfig, sessionName: key, sessionDate: value)
                }
            }
            .navigationTitle(getRaceTitle(race: nextRace))
        }
    }
}

#Preview {
    TimerTab(appData: AppData(), dataConfig: DataConfig())
}
