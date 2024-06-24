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
            Text(entry.name)
                .font(.headline)
            Spacer()
            
            if (entry.tbc) {
                Text("TBC")
                    .font(.headline)
            }
        }
    }
}

#Preview(as: .systemMedium) {
    TimerWidget()
} timeline: {
    TimerEntry(sessions: [], name: "", tbc: true, flag: "")
}
