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
    var ringColor: Color = Color.white;
    var timeUnit: String = "";
    var lineWidth: CGFloat = 10.0;
    
    var body: some View {
        ZStack {
            VStack {
                Text(String(delta))
                    .bold()
                    .font(.title)
                
                Text(timeUnit)
            }
            Circle()
                .trim(from: 0, to: CGFloat(deltaPct))
                .stroke(ringColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: 125, height: 125)
                .rotationEffect(.degrees(270))
                .animation(.easeInOut(duration: 0.3), value: deltaPct)
            
            Circle()
                .stroke(ringColor, lineWidth: lineWidth)
                .opacity(0.5)
                .frame(width: 125, height: 125)
        }.padding(10)
    }
}

#Preview {
    TimerElement()
}
