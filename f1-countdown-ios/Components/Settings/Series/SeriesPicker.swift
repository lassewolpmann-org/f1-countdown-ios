//
//  SeriesPicker.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 5.3.2024.
//

import SwiftUI
import SwiftData

struct SeriesPicker: View {
    @Bindable var appData: AppData;
    @Binding var reloadingData: Bool;

    let availableSeries: [String] = ["f1", "f2", "f3"];
    
    var body: some View {
        Picker(selection: $appData.series) {
            ForEach(availableSeries, id:\.self) { series in
                Text(series.uppercased())
            }
        } label: {
            Text("Select Series")
        }
        .onChange(of: appData.series) { oldValue, newValue in
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
        .sensoryFeedback(.selection, trigger: appData.series)
    }
}

#Preview {
    SeriesPicker(appData: AppData(), reloadingData: .constant(false))
}
