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
    var ringColor: Color = Color.pink;
    var timeUnit: String = "unit";
    var lineWidth: CGFloat = 10;
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(deltaPct))
                .stroke(ringColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(270))
                .animation(.easeInOut(duration: 0.3), value: deltaPct)
                .padding(10)
                .background(Circle().foregroundStyle(ringColor.opacity(0.2)))
            
            VStack {
                Text(String(delta))
                    .bold()
                    .font(.largeTitle)
                
                Text(timeUnit)
                    .foregroundStyle(.gray)
                    .font(.subheadline)
            }
                
        }
    }
}

#Preview {
    TimerElement()
}
