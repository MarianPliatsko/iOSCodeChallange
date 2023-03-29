//
//  File.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-27.
//

import Foundation

struct UserResponse: Decodable {
    let error: ErrorMessage?
    let data: DataClass
}

struct DataClass: Decodable {
    let accessToken, refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

struct ErrorMessage: Decodable {
    let code, message: String
}
