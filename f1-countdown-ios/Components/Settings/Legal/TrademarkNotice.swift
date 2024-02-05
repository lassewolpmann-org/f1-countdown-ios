//
//  TrademarkNotice.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 5.2.2024.
//

import SwiftUI

struct TrademarkNotice: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("This app is unofficial and is not associated in any way with the Formula 1 companies.")
            Text("")
            Text("F1, FORMULA ONE, FORMULA 1, FIA FORMULA ONE WORLD CHAMPIONSHIP, GRAND PRIX and related marks are trade marks of Formula One Licensing B.V.")
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
}

#Preview {
    TrademarkNotice()
}
