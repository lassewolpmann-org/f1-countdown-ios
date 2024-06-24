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
            let flag = CountryFlags().flags[nextRace.localeKey] ?? "";
            let tbc = nextRace.tbc ?? false;
            let name = getRaceTitle(race: nextRace)
            
            return TimerEntry(sessions: appData.nextRaceSessions.map { $0.value }, name: name, tbc: tbc, flag: flag)
        } else {
            return TimerEntry(sessions: [], name: "", tbc: false, flag: "")
        }
    } catch {
        return TimerEntry(sessions: [], name: "", tbc: false, flag: "")
    }
}
