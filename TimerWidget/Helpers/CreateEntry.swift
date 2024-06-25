//
//  CreateEntry.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 7.2.2024.
//

import Foundation

func createEntry(nextRace: RaceData?) async -> TimerEntry {
    if let nextRace {
        do {
            let tbc = nextRace.tbc ?? false;
            let name = getRaceTitle(race: nextRace)
            let nextUpdate = try getNextUpdateDate(nextRace: nextRace)
            let entry = TimerEntry(race: nextRace, name: name, date: nextUpdate, tbc: tbc)
            print(entry)
            
            return entry
        } catch {
            return TimerEntry(race: RaceData(series: "f1"), name: "", date: Date.now, tbc: false)
        }
    } else {
        return TimerEntry(race: RaceData(series: "f1"), name: "", date: Date.now, tbc: false)
    }
}
