//
//  SeriesPicker.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 5.3.2024.
//

import SwiftUI
import SwiftData

struct SeriesPicker: View {
    @Environment(AppData.self) private var appData;
    @Binding var reloadingData: Bool;

    let availableSeries: [String] = ["f1", "f2", "f3"];
    @State private var selectedSeries = "f1";
    
    var body: some View {
        Picker(selection: $selectedSeries) {
            ForEach(availableSeries, id:\.self) { series in
                Text(series.uppercased())
            }
        } label: {
            Text("Select Series")
        }
        .onChange(of: selectedSeries) { oldValue, newValue in
            appData.series = newValue;
            
            Task {
                reloadingData = true;
                
                do {
                    appData.races = try await appData.getAllRaces();
                    reloadingData = false;
                } catch {
                    print("\(error), while changing Series")
                }
            }
        }
        .sensoryFeedback(.selection, trigger: selectedSeries)
    }
}

#Preview {
    SeriesPicker(reloadingData: .constant(false))
        .environment(AppData(series: "f1"))
}
