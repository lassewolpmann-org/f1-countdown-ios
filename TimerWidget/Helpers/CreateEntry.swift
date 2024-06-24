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
            
            return TimerEntry(race: nextRace, tbc: tbc, flag: flag, sessionLengths: nextRace.sessionLengths)
        } else {
            return TimerEntry(race: RaceData(), tbc: false, flag: "", sessionLengths: RaceData().sessionLengths)
        }
    } catch {
        return TimerEntry(race: RaceData(), tbc: false, flag: "", sessionLengths: RaceData().sessionLengths)
    }
}
