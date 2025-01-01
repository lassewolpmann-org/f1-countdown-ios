//
//  SessionsTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI
import SwiftData

struct TimerTab: View {
    @Query var allSeries: [SeriesData]
    var currentSeries: SeriesData? { allSeries.filter({ $0.series == selectedSeries }).first }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let selectedSeries: String
    let notificationController: NotificationController
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                if let nextRace = currentSeries?.nextRace {
                    VStack(alignment: .center, spacing: 15) {
                        ForEach(nextRace.sessions, id: \.shortName) { session in
                            Session(delta: getDelta(session: session), sessionStatus: getSessionStatus(session: session), nextRace: nextRace, selectedSeries: selectedSeries, notificationController: notificationController, session: session)
                        }
                    }
                    .background(FlagBackground(flag: nextRace.flag))
                    .padding(.horizontal, 10)
                    .navigationTitle(nextRace.title)
                } else {
                    Label {
                        Text("It seems like there is no data available to display here.")
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                    }
                    .bold()
                    .symbolRenderingMode(.multicolor)
                    .navigationTitle("Timer")
                }
            }
        }
    }
}

#Preview(traits: .sampleData) {
    TimerTab(selectedSeries: "f1", notificationController: NotificationController())
}
