//
//  Date.swift
//  PersonalDiary
//
//  Created by Karen Khachatryan on 24.11.24.
//

import Foundation

extension Date {
    func toString(format: String = "MMMM dd, HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func stripTime() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
    
    func settingCurrentTime() -> Date? {
            let calendar = Calendar.current
            // Extract the current time components
            let currentTimeComponents = calendar.dateComponents([.hour, .minute, .second], from: Date())
            
            // Create a new date with the same date components but updated with the current time
            return calendar.date(bySettingHour: currentTimeComponents.hour!,
                                 minute: currentTimeComponents.minute!,
                                 second: currentTimeComponents.second!,
                                 of: self)
        }
}
