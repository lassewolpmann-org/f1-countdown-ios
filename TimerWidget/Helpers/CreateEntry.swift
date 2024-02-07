//
//  CreateEntry.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 7.2.2024.
//

import Foundation

func createEntry() async -> TimerEntry {
    let config = DataConfig();
    await config.getConfig()
    
    let data = AppData();
    await data.getData(config: config)
    
    let nextRace = data.nextRaces.first!;
    let flag = CountryFlags().flags[nextRace.localeKey] ?? "";
    let tbc = nextRace.tbc ?? false;
    
    return TimerEntry(race: nextRace, tbc: tbc, flag: flag, sessionLengths: config.sessionLengths)
}
