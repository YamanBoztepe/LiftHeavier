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
    fileprivate let extraButtonView = UIButton()
    fileprivate let extraButtonView2 = UIButton()
    
    let locationManager = CLLocationManager()
    
    fileprivate var timer = Timer()
    fileprivate var stopWatch = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserCoordinate()
        setLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setPulsingView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setPulsingView()
    }
    
    fileprivate func setLayout() {
        
        view.backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        extraView.backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        startButton.isEnabled = false
        extraButtonView.backgroundColor = .clear
        extraButtonView.isEnabled = false
        startButton.backgroundColor = .clear
        extraButtonView2.backgroundColor = .clear
        [pulsingView,extraView,topView,lblWeatherInfo,startButton,lblStart,extraButtonView,extraButtonView2].forEach { view.addSubview($0) }
        
        _ = extraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/17))
        _ = lblWeatherInfo.anchor(top: topView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: view.frame.width/40, bottom: 0, right: view.frame.width/40),size: .init(width: 0, height: view.frame.height/2))
        
        _ = extraButtonView2.anchor(top: nil, bottom: startButton.topAnchor, leading: startButton.leadingAnchor, trailing: startButton.trailingAnchor,padding: .init(top: 0, left: view.frame.width/20, bottom: 0, right: view.frame.width/20),size: .init(width: 0, height: view.frame.height/15))
        _ = startButton.anchor(top: lblWeatherInfo.bottomAnchor, bottom: nil, leading: nil, trailing: nil,padding: .init(top: view.frame.height/10, left: 0, bottom: 0, right: 0))
        _ = extraButtonView.anchor(top: startButton.bottomAnchor, bottom: nil, leading: startButton.leadingAnchor, trailing: startButton.trailingAnchor,padding: .init(top: 0, left: view.frame.width/20, bottom: 0, right: view.frame.width/20),size: .init(width: 0, height: view.frame.height/15))
        
        startButton.positionInCenterSuperView(size: .init(width: view.frame.width/2, height: view.frame.height/12),centerX: view.centerXAnchor, centerY: nil)
        lblStart.positionInCenterSuperView(centerX: startButton.centerXAnchor, centerY: startButton.centerYAnchor)
        
        startButton.circularPath.addArc(withCenter:CGPoint(x: view.frame.width/4, y: view.frame.height/24), radius: view.frame.width/4, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi * 2, clockwise: true)
        
        lblWeatherInfo.font = UIFont.boldSystemFont(ofSize: view.frame.width/15)
        topView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        topView.personalDetailButton.addTarget(self, action: #selector(personalDetailButtonPressed), for: .touchUpInside)
        topView.runningDetailButton.addTarget(self, action: #selector(runningDetailsButtonPressed), for: .touchUpInside)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(startButtonPressed))
        let longGesture2 = UILongPressGestureRecognizer(target: self, action: #selector(extraButtonPressed))
        let longGesture3 = UILongPressGestureRecognizer(target: self, action: #selector(extraButton2Pressed))
        startButton.addGestureRecognizer(longGesture)
        extraButtonView.addGestureRecognizer(longGesture2)
        extraButtonView2.addGestureRecognizer(longGesture3)
    }
    
    fileprivate func setWeatherText() {
        
        let tempMutableAttrText = NSMutableAttributedString(string: WEATHER_TEMP, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        let questionForStart = NSAttributedString(string: CARDIO_QUESTION, attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 0, green: 128, blue: 0)])
        
        guard let weatherInfo = weatherData else {
            tempMutableAttrText.setAttributedString(NSAttributedString(string: ""))
            tempMutableAttrText.append(questionForStart)
            lblWeatherInfo.attributedText = tempMutableAttrText
            startButton.isEnabled = true
            extraButtonView.isEnabled = true
            
            hud.dismiss()
            return
        }
        let temp = Int(weatherInfo.temp - 273.15)
        let humidity = weatherInfo.humidity
        
        var tempAttrText = NSAttributedString()
        
        if temp > 23 {
            tempAttrText = NSAttributedString(string: "\(temp) °C", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        } else {
            tempAttrText = NSAttributedString(string: "\(temp) °C", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
        }
        
        let humidtyMainAttrText = NSAttributedString(string: WEATHER_HUMIDITY,attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        let humidtyAttrText = NSAttributedString(string: "\(humidity)%", attributes: [NSAttributedString.Key.foregroundColor : UIColor.yellow])
        
        [tempAttrText,humidtyMainAttrText,humidtyAttrText,questionForStart].forEach { tempMutableAttrText.append($0) }
        lblWeatherInfo.attributedText = tempMutableAttrText
        startButton.isEnabled = true
        extraButtonView.isEnabled = true
        
        hud.dismiss()
    }
    
    fileprivate func setPulsingView() {
        pulsingView.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        pulsingView.frame.size = CGSize(width: view.frame.width/2.1, height: view.frame.width/2.1)
        pulsingView.center = startButton.center
        pulsingView.clipsToBounds = true
        pulsingView.layer.cornerRadius = view.frame.width/4.2
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 1.5
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        pulsingView.layer.add(animation, forKey: "pulsinAnimation")
    }
   
    fileprivate func popToRootViewControllerWithAnimation() {
        navigationController?.view.layer.add(CATransition().fromLeftToRight(), forKey: nil)
        navigationController?.popToRootViewController(animated: false)
    }
    
    fileprivate func getUserCoordinate() {
        
        if CLLocationManager.authorizationStatus() == .denied {
            let alert = UIAlertController(title: ERROR_ALERT_TITLE, message: ERROR_ALERT_DESCRIPTION, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: ERROR_ALERT_CANCEL, style: .cancel, handler: { (_) in
                self.popToRootViewControllerWithAnimation()
            }))
            alert.addAction(UIAlertAction(title: ERROR_ALERT_SETTINGS, style: .default, handler: { (_) in
                let settingsURL = URL(string: UIApplication.openSettingsURLString)
                UIApplication.shared.open(settingsURL!, options: [:], completionHandler: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
            hud.style = .dark
            hud.show(in: self.view)
        
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestLocation()
        
    }
    
    
    fileprivate func runningButtonActive(sender: UIGestureRecognizer) {
        if sender.state == .began {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(startStopWatch), userInfo: nil, repeats: true)
            pulsingView.backgroundColor = UIColor.purple
            startButton.progressLineBegin()
            
        } else if sender.state == .ended {
            timer.invalidate()
            stopWatch = 0.0
            pulsingView.backgroundColor = UIColor.rgb(red: 0, green: 128, blue: 0)
            startButton.shapeLayer.removeAnimation(forKey: "animation")
        }
    }
    @objc fileprivate func backButtonPressed() {
        popToRootViewControllerWithAnimation()
    }
    @objc fileprivate func startButtonPressed(sender: UIGestureRecognizer) {
        runningButtonActive(sender: sender)
    }
    @objc fileprivate func extraButtonPressed(sender: UIGestureRecognizer) {
        runningButtonActive(sender: sender)
    }
    
    @objc fileprivate func extraButton2Pressed(sender: UIGestureRecognizer) {
        runningButtonActive(sender: sender)
    }
    @objc fileprivate func personalDetailButtonPressed() {
        let vc = UpdateDetailsController()
        navigationController?.view.layer.add(CATransition().fromRightToLeft(), forKey: nil)
        navigationController?.pushViewController(vc, animated: false)
    }
    @objc fileprivate func runningDetailsButtonPressed() {
        let vc = ShowDetailsController()
        navigationController?.view.layer.add(CATransition().fromBottomToTop(), forKey: nil)
        navigationController?.pushViewController(vc, animated: false)
    }
    @objc fileprivate func startStopWatch() {
        stopWatch += 0.1
        if stopWatch >= 1.5 {
            timer.invalidate()
            stopWatch = 0.0
            let vc = RunningMapController()
            navigationController?.view.layer.add(CATransition().fromBottomToTop(), forKey: nil)
            navigationController?.pushViewController(vc, animated: false)
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
        print(error)
    }
    
}
