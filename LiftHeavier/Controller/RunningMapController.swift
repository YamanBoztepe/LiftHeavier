//
//  RunningMapController.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 25.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class RunningMapController: UIViewController {
    
    fileprivate let realm = try! Realm()
    var userLocations = List<LocationDetails>()
    fileprivate var calories = 0
    fileprivate var bmr = 0.0

    fileprivate let extraView = UIView()
    fileprivate let topView = TopViewDownButton()
    fileprivate let runningSummary = RunningSummaryView()
    
    fileprivate var runningDistance: Double = 0.0
    fileprivate var firstLocation: CLLocation!
    fileprivate var lastLocation: CLLocation!
    
    fileprivate let mapView = MKMapView()
    fileprivate let locationManager = CLLocationManager()
    
    fileprivate var counter = 0
    fileprivate var timer = Timer()
    
    fileprivate var pace = 0
    fileprivate var paces = [Int]()
    fileprivate var avgOfPaces = 0
    
    var timer2 = Timer()
    var stopWatch = 0.0
    
    fileprivate let lastRun = LastRunningSummary()
    fileprivate let navigationButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "navigation")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        centerLocationMapView()
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureLocationManager()
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centerLocationMapView()
    }
    
    
    fileprivate func setLayout() {
        view.backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        extraView.backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        [extraView,topView,mapView,navigationButton,runningSummary].forEach { view.addSubview($0) }
        mapView.addSubview(lastRun)
        
        _ = extraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/15))
        _ = lastRun.anchor(top: mapView.topAnchor, bottom: nil, leading: mapView.leadingAnchor, trailing: mapView.trailingAnchor,size: .init(width: 0, height: view.frame.height/7))
        _ = mapView.anchor(top: topView.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = navigationButton.anchor(top: nil, bottom: runningSummary.topAnchor, leading: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 5))
        _ = runningSummary.anchor(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/4.7))
        
        topView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        lastRun.closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        navigationButton.addTarget(self, action: #selector(navigationButtonPressed), for: .touchUpInside)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(stopRunningPressed))
        runningSummary.stopRunning.addGestureRecognizer(longGesture)
        
        navigationButton.isHidden = true
        fetchLastRunData()
    }
    
    fileprivate func centerLocationMapView() {
        mapView.userTrackingMode = .follow
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 600, longitudinalMeters: 600)
        mapView.setRegion(region, animated: true)
    }
    
    
    fileprivate func configureLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 5
    }
    
    fileprivate func finishTheRun() {
        locationManager.stopUpdatingLocation()
        RunningSummayModel.addRunningSummary(duration: counter, distance: runningDistance, avgPace: avgOfPaces, calories: calories, locations: userLocations)
        let vc = RunningDetailsController()
        navigationController?.view.layer.add(CATransition().fromBottomToTop(), forKey: nil)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    fileprivate func calculatePace(time: Int, distance: Double) -> String {
        
        pace = Int(Double(time) / distance)
        calculateAvgOfPace(pace: pace)
        return pace.translateSecondToDuration()
    }
    
    fileprivate func calculateAvgOfPace(pace: Int) {
        paces.append(pace)
        let totalOfPaces = paces.reduce(0) { total,value -> Int in
            return total + value
        }
        avgOfPaces = totalOfPaces / paces.count
    }
    
    fileprivate func calculateCalories(pace: Int, duration: Int) -> Int {
        guard let personalDetail = realm.objects(PersonalDetails.self).first else { return -1 }
        
        if personalDetail.isMale {
            bmr = 10 * personalDetail.weight + 6.25 * personalDetail.height - 5 * Double(personalDetail.age) - 161
            
        } else {
            bmr = 10 * personalDetail.weight + 6.25 * personalDetail.height - 5 * Double(personalDetail.age) + 5
        }
        
        let mph = 60/(pace.translateIntToSecond())
        let metValue = getMetValue(mph: round(mph))
        
        
        calories = Int(((bmr/24) * metValue) * (duration.translateIntToSecond())/60)
        return calories
    }
    
    fileprivate func getMetValue(mph: Double) -> Double {
        var metValue = 0.0
        switch mph {
        case 4:
            metValue = 6
        case 5:
            metValue = 8.3
        case 6:
            metValue = 9.8
        case 7:
            metValue = 11
        case 8:
            metValue = 11.8
        case 9:
            metValue = 12.8
        case 10:
            metValue = 14.5
        case 11:
            metValue = 16
        case 12:
            metValue = 19
        case 13:
            metValue = 19.8
        case 14:
            metValue = 23
        default:
            metValue = 13
        }
        return metValue
    }
    
    fileprivate func startTimer() {
        runningSummary.lblDuration.text = counter.translateSecondToDuration()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    fileprivate func fetchLastRunData() {
        
        guard let lastRunData = RunningSummayModel.fetchRunningSummaries()?.first else { return }
        lastRun.setData(averagePace: lastRunData.avgPace, distance: lastRunData.distance, duration: lastRunData.duration)
    }
    
    fileprivate func drawPolyline(currentLocations: List<LocationDetails>) {
        
        var userCoordinates = [CLLocationCoordinate2D]()
        
        if currentLocations.count > 1 {
            for location in currentLocations {
                userCoordinates.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                if userCoordinates.count == 2 {
                    break
                }
            }
        }
        
        let polyline = MKPolyline(coordinates: userCoordinates, count: userCoordinates.count)
        
        mapView.addOverlay(polyline)
    }
    
    @objc fileprivate func updateCounter() {
        counter += 1
        runningSummary.lblDuration.text = counter.translateSecondToDuration()
    }
    
    @objc fileprivate func stopRunningPressed(sender: UIGestureRecognizer) {
        
        if sender.state == .began {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(startStopWatch), userInfo: nil, repeats: true)
            runningSummary.stopRunning.progressLineBegin()
        } else if sender.state == .ended {
            timer.invalidate()
            stopWatch = 0.0
            runningSummary.stopRunning.shapeLayer.removeAnimation(forKey: "animation")
        }
    }
    
    @objc fileprivate func startStopWatch() {
        stopWatch += 0.1
        if stopWatch >= 1.5 {
            timer.invalidate()
            stopWatch = 0.0
            finishTheRun()
        }
    }
    
    @objc fileprivate func backButtonPressed() {
        locationManager.stopUpdatingLocation()
        navigationController?.view.layer.add(CATransition().fromTopToBottom(), forKey: nil)
        navigationController?.popToRootViewController(animated: false)
    }
    
    @objc fileprivate func closeButtonPressed() {
        lastRun.isHidden = true
    }
    
    @objc fileprivate func navigationButtonPressed() {
        centerLocationMapView()
    }
}

extension RunningMapController: CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        if counter > 0 && runningDistance > 0 {
            if pace.translateIntToSecond() < 4 {
                renderer.strokeColor = .red
            } else if pace.translateIntToSecond() > 4 && pace.translateIntToSecond() < 6 {
                renderer.strokeColor = .yellow
            } else {
                renderer.strokeColor = UIColor.rgb(red: 0, green: 128, blue: 0)
            }
        } else {
            renderer.strokeColor = UIColor.rgb(red: 0, green: 128, blue: 0)
        }
        renderer.lineWidth = 5
        return renderer
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if firstLocation == nil {
            firstLocation = locations.first
        } else if let location = locations.last {
            runningDistance += lastLocation.distance(from: location)
            
            let newLocation = LocationDetails(latitude: Double(lastLocation.coordinate.latitude), longitude: Double(lastLocation.coordinate.longitude))
            self.userLocations.insert(newLocation, at: 0)
            drawPolyline(currentLocations: userLocations)
            
            runningSummary.distance = runningDistance/1609.344
            
            if counter > 0 && runningDistance > 0 {
                runningSummary.pace = calculatePace(time: counter, distance: runningDistance/1609.344)
                runningSummary.calories = calculateCalories(pace: pace, duration: counter)
            }
        }
        
        lastLocation = locations.last
    }
}

extension RunningMapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        
        if mode == .follow {
            navigationButton.isHidden = true
        } else {
            navigationButton.isHidden = false
        }
    }
}
