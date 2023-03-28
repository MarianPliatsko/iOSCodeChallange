//
//  Alert.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-27.
//

import Foundation
import UIKit

extension UIViewController {
    
    func createAlert(alertTitle: String, alertMessage: String, alertActionTitle: String) {
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: alertActionTitle, style: .default) { (action) -> Void in
            print("Ok button tapped")
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    
}
