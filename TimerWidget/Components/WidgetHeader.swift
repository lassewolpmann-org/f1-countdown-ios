//
//  WidgetHeader.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 27.2.2024.
//

import SwiftUI
import WidgetKit

struct WidgetHeader: View {
    let entry: TimerEntry;
    
    var body: some View {
        HStack {
            Text(getRaceTitle(race: entry.race))
                .font(.headline)
            Spacer()
            Text(entry.tbc == true ? "TBC" : "")
                .font(.headline)
                .padding(.vertical, 2)
                .padding(.horizontal, 5)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.red.opacity(0.6))
                )
        }
    }
}

#Preview(as: .systemMedium) {
    TimerWidget()
} timeline: {
    TimerEntry(race: RaceData(), tbc: true, flag: "", sessionLengths: DataConfig().sessionLengths)
}
