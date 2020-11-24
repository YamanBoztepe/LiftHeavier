//
//  WindowSettingsModel.swift
//  LiftBetter
//
//  Created by Yaman Boztepe on 22.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class WindowSettingsModel : Object {
    
    @objc dynamic var windowName : String = "emptyWindowName"
    @objc dynamic var windowColorText : String = ""
    let exercises = List<ExerciseInfoModel>()
    
}
