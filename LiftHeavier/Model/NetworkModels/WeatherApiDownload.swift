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
    
    func jsonDownload() -> WeatherModel? {
        guard let url = url,let apiURL = URL(string: url) else { return nil }
        
        var results: Response?
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: apiURL) { (data, response, error) in
            if let error = error {
                print(error)
                semaphore.signal()
                return
            }
            
            guard let apiData = data else { semaphore.signal();return }
            
            do {
                results = try JSONDecoder().decode(Response.self, from: apiData)
            } catch {
                print("Failed when fetching Json: \(error)")
                semaphore.signal()
                return
            }
            semaphore.signal()
            
            
        }
        task.resume()
        
        semaphore.wait()
        return results?.main
        
        
    }
}
