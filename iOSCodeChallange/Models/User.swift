//
//  User.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-27.
//

import Foundation

class User: Codable {
    let email: String
    let password: String
    
    init() {
        self.email = ""
        self.password = ""
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

