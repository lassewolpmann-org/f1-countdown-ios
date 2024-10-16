//
//  CalendarRace.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 25.7.2024.
//

import SwiftUI

struct CalendarRace: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let race: RaceData

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(race.title)
                .font(.title2)
                .bold()
            
            ForEach(race.sortedSessions, id: \.key) { session in
                VStack {
                    HStack {
                        Text(session.value.longName)
                            .foregroundStyle(.red)
                        Spacer()
                        Text(session.value.dayString)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text(session.value.dateString)
                        Spacer()
                        Text(DateInterval(start: session.value.startDate, end: session.value.endDate))
                    }
                }
                .strikethrough(session.value.endDate.timeIntervalSinceNow < 0)
                .opacity(session.value.endDate.timeIntervalSinceNow < 0 ? 0.5 : 1.0)
            }
        }
        .padding(20)
        .containerRelativeFrame(.horizontal, { length, axis in
            return horizontalSizeClass == .regular
            ? (length / 2) - 10
            : length
        })
        .background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial))
        .background(FlagBackground(flag: race.flag))
    }
}

#Preview {
    CalendarRace(race: RaceData())
}
