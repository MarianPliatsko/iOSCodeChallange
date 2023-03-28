//
//  CalendarDay.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-26.
//

import Foundation

class CalendarDay {
    var day: String!
    var month: Month!
    var event: Shedule?
    
    enum Month {
        case previous
        case current
        case next
    }
}
