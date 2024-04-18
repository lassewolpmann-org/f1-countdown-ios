//
//  WeatherButton.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 18.4.2024.
//

import SwiftUI

struct WeatherButton: View {
    @Binding var showWeatherSheet: Bool;
    
    var body: some View {
        Button {
            showWeatherSheet.toggle()
        } label: {
            Label("Weather", systemImage: "cloud.fill")
                .labelStyle(.iconOnly)
        }
        .frame(width: 30, height: 30)
        .clipShape(Circle())
    }
}

#Preview {
    WeatherButton(showWeatherSheet: .constant(true))
}
