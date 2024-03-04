//
//  SeriesPicker.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 4.3.2024.
//

import SwiftUI

struct SeriesPicker: View {
    let availableOptions: [String] = ["f1", "f2", "f3"];
    @State private var selectionOption: String = "f1";
    
    var body: some View {
        Picker("Select Series", selection: $selectionOption) {
            ForEach(availableOptions, id: \.self) { option in
                switch (option) {
                case "f1":
                    Text("Formula 1")
                case "f2":
                    Text("Formula 2")
                case "f3":
                    Text("Formula 3")
                default:
                    Text("Unknown Series")
                }
            }
        }
        .onAppear {
            // Retrieve saved option
            selectionOption = UserDefaults.standard.string(forKey: "Series") ?? "f1";
        }
        .onChange(of: selectionOption) {
            UserDefaults.standard.set(selectionOption, forKey: "Series")
        }
    }
}

#Preview {
    SeriesPicker()
}
