//
//  ContentView.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 17.4.2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppData.self) private var appData;
    
    var body: some View {
        TabView {
            ForEach(appData.nextRace.futureSessions, id: \.key) { key, value in
                Session(sessionDate: value, sessionName: key, delta: deltaValues(dateString: value))
                    .environment(appData)
            }
        }
        .tabViewStyle(.verticalPage)
    }
}

#Preview {
    ContentView()
        .environment(AppData(series: "f1"))
}
