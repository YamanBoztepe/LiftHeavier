//
//  CompletedExercises.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 5.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class CompletedExercises : Object {
    @objc dynamic var exerciseName : String = "emptyExerciseName"
    @objc dynamic var setNumber : Int = 1
}
