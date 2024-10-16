//
//  TimerCircle.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 17.4.2024.
//

import SwiftUI

struct TimerCircle: View {
    var deltaPct: Float;
    var ringColor: Color;
    
    let lineWidth: CGFloat = 5.5;
    
    var body: some View {
        Circle()
            .trim(from: 0, to: CGFloat(deltaPct))
            .stroke(ringColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .animation(.easeInOut(duration: 0.5), value: deltaPct)
            .rotationEffect(.degrees(270))
            .background(
                Circle()
                    .stroke(ringColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .opacity(0.1)
            )
    }
}

#Preview {
    TimerCircle(deltaPct: 0.5, ringColor: Color.pink)
}
