//
//  RunningController.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 17.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class RunningController: UIViewController {
    
    fileprivate let extraView = UIView()
    fileprivate let topView = TopViewOfRC()
    
    let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=45.508888&lon=-73.561668&appid=7129afc01ab0c5c5aeedc75daaa66abc")

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        
        let weatherData = try! Data(contentsOf: url!)
        let json = try! JSONSerialization.jsonObject(with: weatherData, options: [])
        print(json)
    }
    
    fileprivate func setLayout() {
        view.backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        extraView.backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        
        [extraView,topView].forEach { view.addSubview($0) }
        
        _ = extraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/17))
        
        topView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc fileprivate func backButtonPressed() {
        navigationController?.view.layer.add(CATransition().fromLeftToRight(), forKey: nil)
        navigationController?.popViewController(animated: false)
    }
}
