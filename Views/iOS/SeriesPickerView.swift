//
//  SeriesPicker.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 5.3.2024.
//

import SwiftUI

struct SeriesPicker: View {
    @Binding var selectedSeries: String
    
    var body: some View {
        Picker(selection: $selectedSeries) {
            ForEach(availableSeries, id:\.self) { series in
                Text(series.uppercased())
            }
        } label: {
            Text("Select Series")
        }
        .sensoryFeedback(.selection, trigger: selectedSeries)
    }
}

#Preview {
    SeriesPicker(selectedSeries: .constant("f1"))
}
