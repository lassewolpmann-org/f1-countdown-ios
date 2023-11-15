//
//  RaceTitle.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct RaceTitle: View {
    var raceName: String;
    
    var body: some View {
        Text("F1 \(raceName) Grand Prix")
    }
}

#Preview {
    RaceTitle(raceName: "Preview")
}
