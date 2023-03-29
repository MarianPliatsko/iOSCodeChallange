//
//  Underline.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-28.
//

import Foundation
import UIKit

extension String {
    var underLined: NSAttributedString {
        NSAttributedString(string: self,
                           attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
}
