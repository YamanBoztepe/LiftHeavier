//
//  Extensions+CATransition.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 17.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

extension CATransition {
    
    func fromRightToLeft() -> CATransition {
        duration = 0.3
        timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        type = .push
        subtype = .fromLeft
        return self
    }
    
    func fromLeftToRight() -> CATransition {
        duration = 0.3
        timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        type = .push
        subtype = .fromRight
        return self
    }
    
}
