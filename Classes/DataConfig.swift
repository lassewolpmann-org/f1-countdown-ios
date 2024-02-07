//
//  DataConfig.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 6.2.2024.
//

import Foundation

class DataConfig: Decodable {
    var availableYears: [Int];
    var sessions: [String];
    var sessionLengths: [String: Int];
    
    init() {
        availableYears = [2024];
        sessions = ["undefined 1", "undefined 2"];
        sessionLengths = ["undefined 1": 60, "undefined 2": 30];
    }
    
    func getConfig() async {
        guard let url = URL(string: "https://raw.githubusercontent.com/sportstimes/f1/main/_db/f1/config.json") else {
            return
        };
        
        let request  = URLRequest(url: url);
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request);
            let config = try JSONDecoder().decode(DataConfig.self, from: data);
            
            availableYears = config.availableYears;
            sessions = config.sessions;
            sessionLengths = config.sessionLengths;
        } catch {
            print("Error calling API!")
            print(error)
            
            return
        }
    }
}
