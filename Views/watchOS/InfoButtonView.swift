//
//  InfoButton.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 18.4.2024.
//

import SwiftUI

struct InfoButton: View {
    @Binding var showInfoSheet: Bool;
    
    var body: some View {
        Button {
            showInfoSheet.toggle()
        } label: {
            Label("Information", systemImage: "info.circle.fill")
                .labelStyle(.iconOnly)
        }
        .frame(width: 30, height: 30)
        .clipShape(Circle())
    }
}

#Preview {
    InfoButton(showInfoSheet: .constant(true))
}
