//
//  SessionLengths.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 2.3.2024.
//

import Foundation

struct SessionLengths {
    let series: [String: [String: Double]] = [
        "f1": [
            "fp1": 60,
            "fp2": 60,
            "fp3": 60,
            "qualifying": 60,
            "sprintQualifying": 45,
            "sprint": 30,
            "gp": 120
        ],
        "f2": [
            "practice": 45,
            "qualifying": 30,
            "sprint": 45,
            "feature": 60
        ],
        "f3": [
            "practice": 45,
            "qualifying": 30,
            "sprint": 45,
            "feature": 60
        ]
    ]
}
