//
//  TimerElement.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct TimerElement: View {
    var delta: Int = 0;
    var deltaPct: Float = 0.0;
    var ringColor: Color = Color.pink;
    var timeUnit: String = "unit";
    var lineWidth: CGFloat = 7.5;
    
    var body: some View {
        ZStack {
            VStack {
                Text(String(delta))
                    .bold()
                    .font(.largeTitle)
                
                Text(timeUnit)
                    .foregroundStyle(.gray)
                    .font(.subheadline)
            }
            Circle()
                .trim(from: 0, to: CGFloat(deltaPct))
                .stroke(ringColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(minWidth: 125, maxWidth: 500, minHeight: 125, maxHeight: 500)
                .rotationEffect(.degrees(270))
                .animation(.easeInOut(duration: 0.3), value: deltaPct)
            
            Circle()
                .stroke(ringColor, lineWidth: lineWidth)
                .opacity(0.5)
                .frame(minWidth: 125, maxWidth: 500, minHeight: 125, maxHeight: 500)
        }.padding(10)
    }
}

#Preview {
    TimerElement()
}
