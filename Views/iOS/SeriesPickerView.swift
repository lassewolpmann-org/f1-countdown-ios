//
//  SeriesPicker.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 5.3.2024.
//

import SwiftUI

struct SeriesPicker: View {
    @Bindable var appData: AppData;
    
    var body: some View {
        Picker(selection: $appData.currentSeries) {
            ForEach(appData.availableSeries, id:\.self) { series in
                Text(series.uppercased())
            }
        } label: {
            Text("Select Series")
        }
        .onChange(of: appData.currentSeries) { oldValue, newValue in
            Task {
                do {
                    try await appData.loadAPIData()
                } catch {
                    print("\(error), while changing Series")
                }
            }
        }
        .sensoryFeedback(.selection, trigger: appData.currentSeries)
    }
}

#Preview {
    SeriesPicker(appData: AppData())
}
