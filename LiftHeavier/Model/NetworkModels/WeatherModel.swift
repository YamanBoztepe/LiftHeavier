//
//  WeatherModel.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 19.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

struct WeatherModel: Codable {
    let temp: Double
    let humidity: Int
}

struct Response: Codable {
    let main: WeatherModel
}
