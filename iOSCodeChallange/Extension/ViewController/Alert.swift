//
//  Alert.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-27.
//

import Foundation
import UIKit

extension UIViewController {
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            print("Ok button tapped")
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    
}
