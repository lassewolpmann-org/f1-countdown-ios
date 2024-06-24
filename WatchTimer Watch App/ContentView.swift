//
//  ContentView.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 17.4.2024.
//

import SwiftUI

struct ContentView: View {
    var appData: AppData;
    
    var body: some View {
        TabView {
            if let nextRace = appData.nextRace {
                ForEach(nextRace.futureSessions, id: \.key) { key, value in
                    Session(sessionDate: value, sessionName: key, delta: deltaValues(dateString: value))
                        .environment(appData)
                }
            }
        }
        .tabViewStyle(.verticalPage)
    }
}

#Preview {
    ContentView(appData: AppData())
}
