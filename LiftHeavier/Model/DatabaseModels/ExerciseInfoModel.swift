//
//  ExerciseInfoModel.swift
//  LiftBetter
//
//  Created by Yaman Boztepe on 22.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class ExerciseInfoModel: Object {
    
    @objc dynamic var exerciseName : String = "emptyExerciseName"
    @objc dynamic var setNumber : Int = 1
    var windowSettingMod = LinkingObjects(fromType: WindowSettingsModel.self, property: "exercises")
    let exerciseDateList = List<ExerciseDate>()
}
