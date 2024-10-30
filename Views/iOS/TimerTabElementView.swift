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
    var timeUnit: String;
    
    let ringColor: Color = .gray;
    let lineWidth: CGFloat = 5;
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.regularMaterial)
                    .stroke(ringColor, style: StrokeStyle(lineWidth: 1))
                
                RoundedRectangle(cornerRadius: 10)
                    .trim(from: 0, to: CGFloat(deltaPct))
                    .stroke(ringColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .animation(.easeInOut(duration: 0.5), value: deltaPct)
                    .rotationEffect(.degrees(270))
             
                Text(String(delta))
                    .font(.title2)
                    .bold()
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 100)
            
            Text(timeUnit)
                .foregroundStyle(.secondary)
                .font(.caption)
        }
    }
}

#Preview {
    TimerElement(delta: 30, deltaPct: 0.5, timeUnit: "unit")
}
