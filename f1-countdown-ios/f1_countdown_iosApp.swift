//
//  f1_countdown_iosApp.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI
import Network

@main
struct f1_countdown_iosApp: App {
    @State var dataConfig: DataConfig?;
    @State var appData: AppData?;
    
    @State private var dataLoaded: Bool = false;
    
    var body: some Scene {
        WindowGroup {
            Group {
                if (dataLoaded) {
                    ContentView(appData: appData!, dataConfig: dataConfig!)
                } else {
                    VStack {
                        Text("Loading data...")
                        ProgressView()
                    }
                }
            }.task {
                dataConfig = DataConfig();
                appData = AppData();
                
                await dataConfig?.getConfig();
                await appData?.getData(config: dataConfig!);
                
                await removeInvalidNotifications(races: appData!.nextRaces);
                
                dataLoaded = true;
            }
        }
    }
}
