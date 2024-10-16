//
//  FlagBackground.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 20.8.2024.
//

import SwiftUI

struct FlagBackground: View {
    let flag: String
    
    var body: some View {
        GeometryReader { geo in
            Text(flag)
                .font(.system(size: 1000))
                .minimumScaleFactor(0.005)
                .lineLimit(1)
                .frame(width: geo.size.width, height: geo.size.height)
                .rotationEffect(.degrees(90))
                .blur(radius: 50)
        }
    }
}

#Preview {
    FlagBackground(flag: "🇫🇮")
}
