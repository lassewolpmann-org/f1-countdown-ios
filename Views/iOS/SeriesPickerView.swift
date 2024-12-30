//
//  SeriesPicker.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 5.3.2024.
//

import SwiftUI

struct SeriesPicker: View {
    @State private var seriesSelection: String = "f1"
    
    var body: some View {
        Picker(selection: $seriesSelection) {
            ForEach(availableSeries, id:\.self) { series in
                Text(series.uppercased())
            }
        } label: {
            Text("Select Series")
        }
        .onChange(of: seriesSelection) { _, newSeries in
            print(newSeries)
            /*
            Task {
                do {
                    try await appData.loadAPIData()
                } catch {
                    print("\(error), while changing Series")
                }
            }
             */
        }
        .sensoryFeedback(.selection, trigger: seriesSelection)
    }
}

#Preview {
    SeriesPicker()
}
