//
//  SeasonData.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 1.1.2025.
//

import Foundation

struct Season: Codable {
    struct Race: Codable {
        struct Session: Codable, Equatable {
            enum Status: String, Codable {
                case finished = "Finished"
                case ongoing = "Ongoing"
                case upcoming = "Upcoming"
            }
            
            var rawName: String
            var startDate: Date
            var endDate: Date
            
            var dateString: String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                
                return dateFormatter.string(from: startDate)
            }
            
            var timeString: String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .none
                dateFormatter.timeStyle = .short
                
                return dateFormatter.string(from: startDate)
            }
            
            var dayString: String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                
                return dateFormatter.string(from: startDate)
            }
            
            var dateStringWithoutYear: String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd"
                
                return dateFormatter.string(from: startDate)
            }
            
            var shortName: String {
                switch (self.rawName) {
                case "fp1":
                    return "FP1"
                case "fp2":
                    return "FP2"
                case "fp3":
                    return "FP3"
                case "practice":
                    return "P"
                case "qualifying":
                    return "Q"
                case "qualifying1":
                    return "Q1"
                case "qualifying2":
                    return "Q2"
                case "sprintQualifying":
                    return "SQ"
                case "sprint":
                    return "Sprint"
                case "gp":
                    return "Race"
                case "feature":
                    return "Feature"
                case "race1":
                    return "Race 1"
                case "race2":
                    return "Race 2"
                case "race3":
                    return "Race 3"
                default:
                    return "?"
                }
            }
            
            var longName: String {
                switch (self.rawName) {
                case "fp1":
                    return "Free Practice 1"
                case "fp2":
                    return "Free Practice 2"
                case "fp3":
                    return "Free Practice 3"
                case "practice":
                    return "Practice"
                case "qualifying":
                    return "Qualifying"
                case "qualifying1":
                    return "1st Qualifying"
                case "qualifying2":
                    return "2nd Qualifying"
                case "sprintQualifying":
                    return "Sprint Qualifying"
                case "sprint":
                    return "Sprint"
                case "gp":
                    return "Race"
                case "feature":
                    return "Feature"
                case "race1":
                    return "1st Race"
                case "race2":
                    return "2nd Race"
                case "race3":
                    return "3rd Race"
                default:
                    return "Undefined Session"
                }
            }
        }

        
        var name: String
        var location: String
        var sessions: [Season.Race.Session]
        var slug: String
        var flag: String { flags[self.slug] ?? "" }
        
        var title: String {
            let name = self.name;
            let flag = self.flag;
            
            if (name.contains("Grand Prix")) {
                return "\(flag) \(name)"
            } else {
                return "\(flag) \(name) Grand Prix"
            }
        }
        
        var pastSessions: [Season.Race.Session] { sessions.filter{ $0.endDate < Date.now }}
        var ongoingSessions: [Season.Race.Session] { sessions.filter { $0.startDate < Date() && $0.endDate >= Date() }}
        var futureSessions: [Season.Race.Session] { sessions.filter { $0.startDate >= Date() }}
    }
    
    var year: Int
    var races: [Season.Race]
}
