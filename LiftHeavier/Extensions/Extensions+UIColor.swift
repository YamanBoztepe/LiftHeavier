//
//  Extensions+UIColor.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 24.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

extension UIColor {
    
    func stringToColor(colorName : String) -> UIColor {
        
        switch colorName {
        case "blue":
            return .blue
        case "red":
            return .red
        case "green":
            return .green
        case "purple":
            return .purple
        case "yellow":
            return .systemYellow
        case "pink":
            return .systemPink
        default:
            return .white
        }
    }
}
