//
//  CalendarHepler.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-26.
//

import Foundation

class CalendarHelper {
    
    let calendar = Calendar.current
    
    func plusMonth(date: Date) -> Date {
        
        return calendar.date(byAdding: .month, value: 1, to: date) ?? Date()
    }
    
    func minusMonth(date: Date) -> Date {
        
        return calendar.date(byAdding: .month, value: -1, to: date) ?? Date()
    }
    
    func monthToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date)
    }
    
    func monthToStringNumber(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: date)
    }
    
    func yearToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    func daysInMonth(date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count ?? 0
    }
    
    func dayOfMonth(date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day ?? 0
    }
    
    func firstOfMonth(date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? Date()
    }
    
    func weekDay(date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 2
    }
    
    func getCurrentDay() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let dayOfMonth = dateFormatter.string(from: now)
        return dayOfMonth
    }
    
    func getCurrentMonth() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let monthOfYear = dateFormatter.string(from: now)
        return monthOfYear
    }
    
}
