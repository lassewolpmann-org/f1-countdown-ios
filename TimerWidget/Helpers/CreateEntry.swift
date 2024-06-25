//
//  CreateEntry.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 7.2.2024.
//

import Foundation

func createEntry() async -> TimerEntry {
    do {
        let appData = AppData();
        appData.races = try await appData.getAllRaces();
        if let nextRace = appData.nextRace {
            let tbc = nextRace.tbc ?? false;
            let name = getRaceTitle(race: nextRace)
            
            return TimerEntry(race: nextRace, name: name, tbc: tbc)
        } else {
            return TimerEntry(race: RaceData(series: "f1"), name: "", tbc: false)
        }
    } catch {
        return TimerEntry(race: RaceData(series: "f1"), name: "", tbc: false)
    }
}
