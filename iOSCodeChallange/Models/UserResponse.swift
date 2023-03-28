//
//  File.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-27.
//

import Foundation

class UserResponse: Codable {
    let error: ErrorMessage?
    let data: DataClass

    init(error: ErrorMessage?, data: DataClass) {
        self.error = error
        self.data = data
    }
}

class DataClass: Codable {
    let accessToken, refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }

    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

class ErrorMessage: Codable {
    let code, message: String

    init(code: String, message: String) {
        self.code = code
        self.message = message
    }
}
