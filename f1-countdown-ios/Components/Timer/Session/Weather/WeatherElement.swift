//
//  WeatherElement.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 20.2.2024.
//

import SwiftUI

struct WeatherElement: View {
    let labelText: String;
    let systemImage: String;
    let weatherText: String;
    
    var body: some View {
        HStack {
            Label(labelText, systemImage: systemImage)
                .foregroundStyle(.secondary)
            Spacer()
            Text(weatherText)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(.tertiary.opacity(0.5).shadow(.drop(color: .primary, radius: 5)))
        )
    }
}

#Preview {
    WeatherElement(labelText: "Weather", systemImage: "cloud", weatherText: "Weather")
}
