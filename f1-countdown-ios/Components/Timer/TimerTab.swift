//
//  SessionsTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct TimerTab: View {
    var appData: AppData;

    @State var showFinishedSessions = false
    @State var showOngoingSessions = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                if let nextRace = appData.nextRace {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            let finishedSessionCount = nextRace.pastSessions.count
                            
                            Text("\(finishedSessionCount) Finished \(finishedSessionCount == 1 ? "Session" : "Sessions")")
                                .font(.subheadline)
                                .bold()
                            
                            Button {
                                showFinishedSessions.toggle()
                            } label: {
                                Image(systemName: "eye.slash.circle")
                                    .hidden()
                                    .overlay {
                                        Image(systemName:
                                            showFinishedSessions ?
                                              "eye.slash.circle" :
                                                "eye.circle"
                                        )
                                    }
                            }
                        }
                        
                        if (showFinishedSessions) {
                            if (nextRace.pastSessions.isEmpty) {
                                Label {
                                    Text("No finished Sessions")
                                } icon: {
                                    Image(systemName: "clock.badge.exclamationmark")
                                }
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .symbolRenderingMode(.multicolor)
                                .padding(10)
                                .background(.ultraThinMaterial, in:
                                    RoundedRectangle(cornerRadius: 10)
                                )
                            } else {
                                ForEach(nextRace.pastSessions, id: \.key) { session in
                                    Session(appData: appData, nextRace: nextRace, session: session.value, delta: session.value.delta)
                                }
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            let ongoingSessionCount = nextRace.ongoingSessions.count
                            Text("\(ongoingSessionCount) Ongoing \(ongoingSessionCount == 1 ? "Session" : "Sessions")")
                                .font(.subheadline)
                                .bold()
                            
                            Button {
                                showOngoingSessions.toggle()
                            } label: {
                                Image(systemName: "eye.slash.circle")
                                    .hidden()
                                    .overlay {
                                        Image(systemName:
                                                showOngoingSessions ?
                                              "eye.slash.circle" :
                                                "eye.circle"
                                        )
                                    }
                            }
                        }
                                                
                        if (showOngoingSessions) {
                            if (nextRace.ongoingSessions.isEmpty) {
                                Label {
                                    Text("No ongoing Sessions")
                                } icon: {
                                    Image(systemName: "clock.badge.exclamationmark")
                                }
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .symbolRenderingMode(.multicolor)
                                .padding(10)
                                .background(.ultraThinMaterial, in:
                                    RoundedRectangle(cornerRadius: 10)
                                )
                            } else {
                                ForEach(nextRace.ongoingSessions, id: \.key) { session in
                                    Session(appData: appData, nextRace: nextRace, session: session.value, delta: session.value.delta)
                                }
                            }
                        }

                        Divider()

                        let upcomingSessionCount = nextRace.futureSessions.count
                        
                        Text("\(upcomingSessionCount) Upcoming \(upcomingSessionCount == 1 ? "Session" : "Sessions")")
                            .font(.subheadline)
                            .bold()

                        ForEach(nextRace.futureSessions, id: \.key) { session in
                            Session(appData: appData, nextRace: nextRace, session: session.value, delta: session.value.delta)
                        }
                    }
                    .padding(.horizontal, 10)
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
    let appData = AppData()
    appData.races = [RaceData(series: "f1")]
    
    return TimerTab(appData: appData)
}
