//
//  Security.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-27.
//

import Foundation
import Security

class Keychain {
    
    func deleteCredentials() {
        let secItemClasses = [kSecClassGenericPassword,
                              kSecClassInternetPassword,
                              kSecClassCertificate,
                              kSecClassKey,
                              kSecClassIdentity]
        for secItemClass in secItemClasses {
            let dictionary = [kSecClass as String:secItemClass]
            SecItemDelete(dictionary as CFDictionary)
        }
    }
    
    func saveCredentials(username: String, password: String) {
        let data = password.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "your.server.com",
            kSecAttrAccount as String: username as AnyObject,
            kSecValueData as String: data,
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Failed to save credentials")
            return
        }
        print("Credentials saved successfully")
    }
    
    func getCredentials(account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "your.server.com",
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue ?? Date(),
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            print("Credentials not found")
            return nil
        }
        return item as? Data
        
    }
    
}
