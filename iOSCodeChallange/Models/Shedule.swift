//
//  Shedule.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-27.
//

import Foundation

struct Shedule: Decodable {
    let error: ErrorMessage?
    let data: [SheduleData]
}

struct SheduleData: Decodable {
    let courseName, room, startTime, emdTime: String

    enum CodingKeys: String, CodingKey {
        case courseName = "course_name"
        case room
        case startTime = "start_time"
        case emdTime = "emd_time"
    }
}
