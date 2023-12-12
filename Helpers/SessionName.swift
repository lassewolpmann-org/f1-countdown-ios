//
//  SessionName.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 29.11.2023.
//

import Foundation

func parseSessionName(sessionName: String?) -> String {
    let name = sessionName ?? "undefined"
    
    if (name == "fp1") {
        return "Free Practice 1"
    } else if (name == "fp2") {
        return "Free Practice 2"
    } else if (name == "fp3") {
        return "Free Practice 3"
    } else if (name == "qualifying") {
        return "Qualifying"
    } else if (name == "sprintQualifying") {
        return "Sprint Qualifying"
    } else if (name == "gp") {
        return "Race"
    } else {
        return "Undefined Session"
    }
}
