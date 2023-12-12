//
//  TimerElement.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct TimerElement: View {
    var delta: Int = 0;
    var deltaPct: Float = 0.5;
    var ringColor: Color = Color.green;
    var timeUnit: String = "unit";
    var lineWidth: CGFloat = 10;
    
    var body: some View {
        ZStack {
            Circle()
                .fill(ringColor.shadow(.drop(color: ringColor, radius: 5)))
                .opacity(0.25)
            
            Circle()
                .trim(from: 0, to: CGFloat(deltaPct))
                .stroke(ringColor.shadow(.drop(color: ringColor, radius: 5)), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .opacity(0.75)
                .animation(.easeInOut(duration: 0.5), value: deltaPct)
                .rotationEffect(.degrees(270))
                .padding(lineWidth / 2)
            
            VStack {
                Text(String(delta))
                    .font(.title)
                    .bold()
                    .foregroundStyle(.primary)
                
                Text(timeUnit)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }.padding(5)
    }
}

#Preview {
    TimerElement()
}
