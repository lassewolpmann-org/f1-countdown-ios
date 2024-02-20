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
    let weatherText: String ;
    
    var body: some View {
        Divider()
        HStack {
            Label(labelText, systemImage: systemImage)
                .foregroundStyle(.secondary)
            Spacer()
            Text(weatherText).font(.title2)
        }
    }
}

#Preview {
    WeatherElement(labelText: "Weather", systemImage: "cloud", weatherText: "Weather")
}
