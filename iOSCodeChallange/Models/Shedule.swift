//
//  Shedule.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-27.
//

import Foundation

class Shedule: Codable {
    let error: SheduleError?
    let data: [SheduleData]
    
    init() {
        self.error = SheduleError()
        self.data = [SheduleData]()
    }

    init(error: SheduleError?, data: [SheduleData]) {
        self.error = error
        self.data = data
    }
}

class SheduleData: Codable {
    let courseName, room, startTime, emdTime: String

    enum CodingKeys: String, CodingKey {
        case courseName = "course_name"
        case room
        case startTime = "start_time"
        case emdTime = "emd_time"
    }
    
    init() {
        self.courseName = ""
        self.room = ""
        self.startTime = ""
        self.emdTime = ""
    }

    init(courseName: String, room: String, startTime: String, emdTime: String) {
        self.courseName = courseName
        self.room = room
        self.startTime = startTime
        self.emdTime = emdTime
    }
}

class SheduleError: Codable {
    let code, message: String
    
    init() {
        self.code = ""
        self.message = ""
    }

    init(code: String, message: String) {
        self.code = code
        self.message = message
    }
}
