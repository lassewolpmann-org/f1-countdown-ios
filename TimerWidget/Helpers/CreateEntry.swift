//
//  CreateEntry.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 7.2.2024.
//

import Foundation

func createEntry() async -> TimerEntry {
    do {
        let config = try await DataConfig().config;
        let nextRace = try await AppData().nextRace;
        
        let flag = CountryFlags().flags[nextRace.localeKey] ?? "";
        let tbc = nextRace.tbc ?? false;
        
        return TimerEntry(race: nextRace, tbc: tbc, flag: flag, sessionLengths: config.sessionLengths)
    } catch {
        return TimerEntry(race: RaceData(), tbc: false, flag: "", sessionLengths: DataConfig().sessionLengths)
    }
}
