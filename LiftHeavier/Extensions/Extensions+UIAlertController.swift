//
//  Extensions+UIAlertController.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 6.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func setMessage(text: String,color: UIColor) {
        guard let message = self.message else { return }
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, message.count))
        self.setValue(attrString, forKey: "attributedMessage")
    }
}
