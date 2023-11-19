//
//  SessionDetails.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 19.11.2023.
//

import SwiftUI

struct SessionDetails: View {
    var raceName: String;
    
    var sessionName: String?;
    var sessionDate: String?;
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(parseSessionName(sessionName: sessionName ?? "fp1"))
                .font(.title2)
                .padding(.bottom, 5)
            
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(getDay(dateString: sessionDate ?? "1970-01-01T00:00:00Z"))
                    Text("from \(getTime(dateString: sessionDate ?? "1970-01-01T00:00:00Z"))")
                }.frame(maxWidth: .infinity, alignment: .leading)
                
                NotificationButton(raceName: raceName, sessionName: sessionName ?? "fp1", sessionDate: sessionDate ?? "1970-01-01T00:00:00Z")
            }
        }
    }
}

#Preview {
    SessionDetails(raceName: "undefined")
}
