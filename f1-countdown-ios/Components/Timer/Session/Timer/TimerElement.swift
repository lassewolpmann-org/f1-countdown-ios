//
//  TimerElement.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct TimerElement: View {
    var delta: Int;
    var deltaPct: Float;
    var ringColor: Color;
    var timeUnit: String;
    
    let lineWidth: CGFloat = 5;
    
    var body: some View {
        ZStack {
            Circle()
                .fill(ringColor)
                .opacity(0.25)
            
            Circle()
                .trim(from: 0, to: CGFloat(deltaPct))
                .stroke(ringColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .opacity(0.75)
                .animation(.easeInOut(duration: 0.5), value: deltaPct)
                .rotationEffect(.degrees(270))
                .padding(lineWidth / 2)
            
            VStack {
                Text(String(delta))
                    .font(.headline)
                
                Text(timeUnit)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: 100, maxHeight: 100)
    }
}

#Preview {
    TimerElement(delta: 30, deltaPct: 0.5, ringColor: .pink, timeUnit: "unit")
}
