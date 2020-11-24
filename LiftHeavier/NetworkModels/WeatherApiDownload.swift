//
//  WeatherApiDownload.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 19.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class WeatherApiDownload {
    var url: String?
    
    init(url: String) {
        self.url = url
    }
    
    func jsonDownload() -> WeatherModel {
        guard let url = url,let apiURL = URL(string: url) else { return WeatherModel(temp: -111, humidity: -111) }
        
        var results: Response?
        let task = URLSession.shared.dataTask(with: apiURL) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let apiData = data else { return }
            
            do {
                results = try JSONDecoder().decode(Response.self, from: apiData)
            } catch {
                print("Failed when fetching Json: \(error.localizedDescription)")
                return
            }
        }
        task.resume()
        
        
        while 0 < 1 {
            if results != nil {
                return results!.main
            } else {
                continue
            }
        }
        
        
    }
}
