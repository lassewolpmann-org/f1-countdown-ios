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
            ForEach(appData.nextRaceSessions, id: \.key) { session in
                Session(appData: appData, session: session.value, delta: session.value.delta)
            }
        }
        .tabViewStyle(.verticalPage)
    }
}

#Preview {
    ContentView(appData: AppData())
}
