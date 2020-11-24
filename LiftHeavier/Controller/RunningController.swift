//
//  RunningController.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 17.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import CoreLocation
import JGProgressHUD

class RunningController: UIViewController {
    
    let hud = JGProgressHUD()
    
    fileprivate let extraView = UIView()
    fileprivate let topView = TopViewOfRC()
    
    var url = "https://api.openweathermap.org/data/2.5/weather"
    var weatherData: WeatherModel? {
        didSet {
            setWeatherText()
        }
    }
    
    fileprivate let lblWeatherInfo : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    fileprivate let startButton = CustomAnimationButton()
    fileprivate let pulsingView = UILabel()
    fileprivate let lblStart : UILabel = {
        let lbl = UILabel()
        lbl.text = START_BUTTON
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserCoordinate()
        setLayout()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setPulsingView()
        
    }
    
    fileprivate func setLayout() {
        view.backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        extraView.backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        
        view.addSubview(pulsingView)
        [extraView,topView,lblWeatherInfo,startButton,lblStart].forEach { view.addSubview($0) }
        
        _ = extraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/17))
        _ = lblWeatherInfo.anchor(top: topView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: view.frame.width/40, bottom: 0, right: view.frame.width/40),size: .init(width: 0, height: view.frame.height/2))
        _ = startButton.anchor(top: lblWeatherInfo.bottomAnchor, bottom: nil, leading: nil, trailing: nil)
        startButton.positionInCenterSuperView(size: .init(width: view.frame.width/2, height: view.frame.height/12),centerX: view.centerXAnchor, centerY: nil)
        lblStart.positionInCenterSuperView(centerX: startButton.centerXAnchor, centerY: startButton.centerYAnchor)
        
        startButton.circularPath.addArc(withCenter:CGPoint(x: view.frame.width/4, y: view.frame.height/24), radius: view.frame.width/4, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi * 2, clockwise: true)
        lblWeatherInfo.font = UIFont.boldSystemFont(ofSize: view.frame.width/15)
        topView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(startButtonPressed))
        startButton.addGestureRecognizer(longGesture)
    }
    
    fileprivate func setWeatherText() {
        guard let weatherInfo = weatherData else { return }
        let temp = Int(weatherInfo.temp - 273.15)
        let humidity = weatherInfo.humidity
        
        var tempAttrText = NSAttributedString()
        
        let tempMutableAttrText = NSMutableAttributedString(string: WEATHER_TEMP, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        if temp > 23 {
            tempAttrText = NSAttributedString(string: "\(temp) °C", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        } else {
            tempAttrText = NSAttributedString(string: "\(temp) °C", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
        }
        
        let humidtyMainAttrText = NSAttributedString(string: WEATHER_HUMIDITY,attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        let humidtyAttrText = NSAttributedString(string: "\(humidity)%", attributes: [NSAttributedString.Key.foregroundColor : UIColor.yellow])
        
        let questionForStart = NSAttributedString(string: CARDIO_QUESTION, attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 0, green: 128, blue: 0)])
        
        [tempAttrText,humidtyMainAttrText,humidtyAttrText,questionForStart].forEach { tempMutableAttrText.append($0) }
        lblWeatherInfo.attributedText = tempMutableAttrText
        hud.dismiss()
    }
    
    fileprivate func getUserCoordinate() {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            hud.style = .dark
            hud.show(in: self.view)
            locationManager.delegate = self
            locationManager.requestLocation()
        }
    }
    
    fileprivate func setPulsingView() {
        pulsingView.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        pulsingView.frame.size = CGSize(width: view.frame.width/2.2, height: view.frame.width/2.2)
        pulsingView.center = startButton.center
        pulsingView.clipsToBounds = true
        pulsingView.layer.cornerRadius = view.frame.width/4.4
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 1.5
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        pulsingView.layer.add(animation, forKey: "pulsinAnimation")
    }
    
    @objc fileprivate func backButtonPressed() {
        navigationController?.view.layer.add(CATransition().fromLeftToRight(), forKey: nil)
        navigationController?.popViewController(animated: false)
    }
    @objc fileprivate func startButtonPressed(sender: UIGestureRecognizer) {
        if sender.state == .began {
            pulsingView.backgroundColor = UIColor.gray
            startButton.progressLineBegin()
            
        } else if sender.state == .ended {
            print(startButton.traceLayer.presentation()?.value(forKeyPath: "strokeStart") ?? 0.0)
            pulsingView.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 0)
            startButton.shapeLayer.removeAnimation(forKey: "animation")
        }
    }
}

extension RunningController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        url += "?lat=\(location.latitude)&lon=\(location.longitude)&appid=7129afc01ab0c5c5aeedc75daaa66abc"
        weatherData = WeatherApiDownload(url: url).jsonDownload()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
