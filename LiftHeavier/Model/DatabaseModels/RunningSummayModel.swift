//
//  RunningSummayModel.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 10.12.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import Foundation
import RealmSwift

class RunningSummayModel : Object {
    
    @objc dynamic var id = ""
    @objc dynamic var date = NSDate()
    @objc dynamic var avgPace = 0
    @objc dynamic var distance = 0.0
    @objc dynamic var duration = 0
    @objc dynamic var calories = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["date","avgPace","duration"]
    }
    
    convenience init(avgPace: Int, duration: Int, distance: Double) {
        
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSDate()
        self.distance = distance
        self.duration = duration
        self.avgPace = avgPace
    }
    
    static func addRunningSummary(duration: Int, distance: Double, avgPace: Int) {
        
        let currentSummary = RunningSummayModel(avgPace: avgPace, duration: duration, distance: distance)
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(currentSummary)
            }
            
        } catch {
            print("error when try to add running infos into the realm : \(error.localizedDescription)")
        }
    }
    
    static func fetchRunningSummaries() -> Results<RunningSummayModel>? {
        
        do {
            
            let realm = try Realm()
            var runningSummaries = realm.objects(RunningSummayModel.self)
            runningSummaries = runningSummaries.sorted(byKeyPath: "date", ascending: false)
            return runningSummaries
            
        } catch {
            print("error when try to fetch running infos from the realm : \(error.localizedDescription)")
        }
        return nil
    }
    
    func getCalories() -> Int {
        return self.calories
    }
}
