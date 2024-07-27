//
//  UserDefaultsController.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 26.7.2024.
//

import Foundation

@Observable class UserDefaultsController {
    struct ReturnMessage {
        var success: Bool?
        var message: String
    }
    
    let key: String = "NotificationOffsets"
    let userDefaults = UserDefaults.standard
    
    var selectedOffsetOptions: [Int] = []
    var message: ReturnMessage = ReturnMessage(success: nil, message: "")
    
    init() {
        if (self.offsetValues.isEmpty) {
            self.selectedOffsetOptions = [0]
            userDefaults.set(self.selectedOffsetOptions, forKey: self.key)
        } else {
            selectedOffsetOptions = self.offsetValues
        }
    }
    
    func toggleOffsetValue(offset: Int) -> Void {
        var currentValues = self.offsetValues
                
        if (currentValues.contains(offset)) {
            guard currentValues.count > 1 else {
                message.success = false
                message.message = "Cannot remove only selected option"
                
                return
            }
            
            // Remove offset
            if let i = currentValues.firstIndex(of: offset) {
                currentValues.remove(at: i)
                message.success = true
                message.message = "Removed option"
            } else {
                message.success = false
                message.message = "Could not find option in list of selected options"
            }
        } else {
            // Append offset
            currentValues.append(offset)
            
            message.success = true
            message.message = "Added option"
        }
        
        self.selectedOffsetOptions = currentValues
        userDefaults.set(self.selectedOffsetOptions, forKey: self.key)
    }
    
    var offsetValues: [Int] {
        let values = userDefaults.array(forKey: self.key)  as? [Int] ?? []
        
        return values.sorted { a, b in
            a < b
        }
    }
}
