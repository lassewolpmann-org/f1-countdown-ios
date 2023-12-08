//
//  InformationLink.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 7.12.2023.
//

import SwiftUI

struct InformationLink: View {
    var body: some View {
        NavigationLink {
            AppInformation()
        } label: {
            Label("Information", systemImage: "info.circle")
        }
    }
}

#Preview {
    InformationLink()
}
