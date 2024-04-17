//
//  Session.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 17.4.2024.
//

import SwiftUI

struct Session: View {
    @Environment(AppData.self) private var appData;
    let sessionDate: String;
    let sessionName: String;
    
    @State var delta: deltaValues;
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
    
    var body: some View {
        ZStack {
            Text("\(appData.nextRace.flag) \(parseShortSessionName(sessionName: sessionName))")
                .font(.headline)
                .frame(width: 100, height: 100)
            
            TimerCircle(deltaPct: delta.daysPct, ringColor: .primary)
            TimerCircle(deltaPct: delta.hoursPct, ringColor: .red)
                .padding(8)
            TimerCircle(deltaPct: delta.minutesPct, ringColor: .green)
                .padding(16)
            TimerCircle(deltaPct: delta.secondsPct, ringColor: .blue)
                .padding(24)
        }
        .scaledToFit()
        .onReceive(timer) { _ in
            delta = deltaValues(dateString: sessionDate);
            
            if (delta.delta == 0) {
                Task {
                    do {
                        appData.races = try await appData.getAllRaces();
                    } catch {
                        print("\(error), while updating appData in Session")
                    }
                }
            }
        }
    }
}

#Preview {
    TabView {
        let nextRace = RaceData();
        let firstSession = nextRace.futureSessions.first!;
        
        Session(sessionDate: firstSession.value, sessionName: firstSession.key, delta: deltaValues(dateString: Date().ISO8601Format()))
            .environment(AppData(series: "f1"))
    }
    .tabViewStyle(.verticalPage)
}
