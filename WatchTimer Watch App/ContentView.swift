//
//  ContentView.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 17.4.2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppData.self) private var appData;
    @State var delta: deltaValues?;
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
    
    var body: some View {
        let nextSession = appData.nextRace.futureSessions.first!;
        let sessionName: String = nextSession.key;
        let sessionDate: String = nextSession.value;
        
        ZStack {
            Text("\(appData.nextRace.flag) \(parseSessionName(sessionName: sessionName))")
                .font(.headline)
                .frame(width: 100, height: 100)
            
            Circle()
                .trim(from: 0, to: CGFloat(delta?.daysPct ?? 1.0))
                .stroke(.primary, style: StrokeStyle(lineWidth: 9.5, lineCap: .round))
                .animation(.easeInOut(duration: 0.5), value: delta?.daysPct ?? 1.0)
                .rotationEffect(.degrees(270))
                .background(
                    Circle()
                        .stroke(.primary, style: StrokeStyle(lineWidth: 9.5, lineCap: .round))
                        .opacity(0.1)
                )
                .frame(width: 120, height: 120)
            Circle()
                .trim(from: 0, to: CGFloat(delta?.hoursPct ?? 1.0))
                .stroke(.red, style: StrokeStyle(lineWidth: 9.5, lineCap: .round))
                .animation(.easeInOut(duration: 0.5), value: delta?.hoursPct ?? 1.0)
                .rotationEffect(.degrees(270))
                .background(
                    Circle()
                        .stroke(.red, style: StrokeStyle(lineWidth: 9.5, lineCap: .round))
                        .opacity(0.1)
                )
                .frame(width: 140, height: 140)
            Circle()
                .trim(from: 0, to: CGFloat(delta?.minutesPct ?? 1.0))
                .stroke(.green, style: StrokeStyle(lineWidth: 9.5, lineCap: .round))
                .animation(.easeInOut(duration: 0.5), value: delta?.minutesPct ?? 1.0)
                .rotationEffect(.degrees(270))
                .background(
                    Circle()
                        .stroke(.green, style: StrokeStyle(lineWidth: 9.5, lineCap: .round))
                        .opacity(0.1)
                )
                .frame(width: 160, height: 160)
            Circle()
                .trim(from: 0, to: CGFloat(delta?.secondsPct ?? 1.0))
                .stroke(.blue, style: StrokeStyle(lineWidth: 9.5, lineCap: .round))
                .animation(.easeInOut(duration: 0.5), value: delta?.secondsPct ?? 1.0)
                .rotationEffect(.degrees(270))
                .background(
                    Circle()
                        .stroke(.blue, style: StrokeStyle(lineWidth: 9.5, lineCap: .round))
                        .opacity(0.1)
                )
                .frame(width: 180, height: 180)
        }
        .onReceive(timer) { _ in
            delta = deltaValues(dateString: sessionDate);
            
            if (delta?.delta == 0) {
                Task {
                    do {
                        appData.races = try await appData.getAllRaces();
                    } catch {
                        print("\(error), while updating appData in Session")
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(delta: deltaValues(dateString: ISO8601DateFormatter().string(from: Date())))
        .environment(AppData(series: "f1"))
}
