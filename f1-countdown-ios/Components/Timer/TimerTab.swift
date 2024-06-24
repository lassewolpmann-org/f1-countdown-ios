//
//  SessionsTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct TimerTab: View {
    var appData: AppData;

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                if let nextRace = appData.nextRace {
                    VStack(spacing: 15) {
                        ForEach(nextRace.futureSessions, id: \.key) { name, date in
                            Session(appData: appData, sessionName: name, sessionDate: date, nextRace: nextRace, delta: deltaValues(dateString: date))
                        }
                    }
                    .navigationTitle(getRaceTitle(race: nextRace))
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
            .background(
                GeometryReader { geo in
                    if let flag = appData.nextRace?.flag {
                        Text(flag)
                            .font(.system(size: 1000))
                            .minimumScaleFactor(0.005)
                            .lineLimit(1)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .rotationEffect(.degrees(90))
                            .blur(radius: 50)
                    }
                }
            )
        }
        .refreshable {
            do {
                appData.races = try await appData.getAllRaces()
            } catch {
                print("\(error), while refreshing TimerTab")
            }
        }
    }
}

#Preview {
    return TimerTab(appData: AppData())
}
