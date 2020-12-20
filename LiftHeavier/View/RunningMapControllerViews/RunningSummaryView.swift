//
//  RunningSummaryView.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 5.12.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class RunningSummaryView: UIView {
    
    fileprivate let lblStop : UILabel = {
        let lbl = UILabel()
        lbl.text = STOP_BUTTON
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    let stopRunning = CustomAnimationButton()
    
    let lblDuration : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.text = "00:00:00"
        lbl.textAlignment = .center
        return lbl
    }()
    
    fileprivate let lblDistanceText : UILabel = {
        let lbl = UILabel()
        lbl.text = DISTANCE
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
    fileprivate let lblDistance : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
    var distance : Double? {
        didSet {
            guard let dst = distance else { return }
            lblDistance.text = String(format: "%.3f",dst)
        }
    }
    
    fileprivate let lblPaceText : UILabel = {
        let lbl = UILabel()
        lbl.text = PACE
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
    fileprivate let lblPace : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
    var pace : String? {
        didSet {
            lblPace.text = pace
        }
    }
    
    fileprivate let lblCaloriesText : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = CAL
        lbl.textColor = .white
        return lbl
    }()
    
    fileprivate let lblCalories : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
    
    var calories : Int? {
        didSet {
            guard let cal = calories else { return }
            lblCalories.text = "\(cal)"
        }
    }
    
    fileprivate let bottomStackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 5
        return sv
    }()
    
    fileprivate let distanceStackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.backgroundColor = .rgb(red: 0, green: 0, blue: 255)
        return sv
    }()
    fileprivate let paceStackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.backgroundColor = .rgb(red: 0, green: 128, blue: 0)
        return sv
    }()
    fileprivate let caloriesStackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.backgroundColor = .rgb(red: 255, green: 0, blue: 0)
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
        distance = 0.0
        pace = "0:00"
        calories = 0
    }
    
    
    fileprivate func setLayout() {
        backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        stopRunning.backgroundColor = .clear
        
        [lblCaloriesText,lblCalories].forEach { caloriesStackView.addArrangedSubview($0) }
        [lblDistanceText,lblDistance].forEach { distanceStackView.addArrangedSubview($0) }
        [lblPaceText,lblPace].forEach { paceStackView.addArrangedSubview($0) }
        
        [distanceStackView,paceStackView,caloriesStackView].forEach { bottomStackView.addArrangedSubview($0) }
        
        [stopRunning,lblStop,lblDuration,bottomStackView].forEach { addSubview($0) }
        
        _ = lblDuration.anchor(top: topAnchor, bottom: bottomStackView.topAnchor, leading: bottomStackView.leadingAnchor, trailing: bottomStackView.trailingAnchor,size: .init(width: 0, height: frame.height/2.5))
        _ = bottomStackView.anchor(top: nil, bottom: safeAreaLayoutGuide.bottomAnchor, leading: leadingAnchor, trailing: stopRunning.leadingAnchor,padding: .init(top: frame.height/10, left: frame.width/60, bottom: 0, right: frame.width/60))
        
        _ = stopRunning.anchor(top: topAnchor, bottom: nil, leading: nil, trailing: trailingAnchor, padding: .init(top: frame.height/4, left: 0, bottom: 0, right: frame.width/20),size: .init(width: frame.width/5, height: frame.height/2))
        stopRunning.circularPath.addArc(withCenter:CGPoint(x: frame.width/10, y: frame.height/4), radius: frame.width/10, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi * 2, clockwise: true)
        
        _ = lblStop.anchor(top: stopRunning.topAnchor, bottom: stopRunning.bottomAnchor, leading: stopRunning.leadingAnchor, trailing: stopRunning.trailingAnchor)
        
        [distanceStackView,paceStackView,caloriesStackView].forEach { $0.layer.cornerRadius = frame.width/30 }
        
        [lblStop,lblDistanceText,lblPaceText,lblCaloriesText].forEach { $0.font = UIFont.boldSystemFont(ofSize: frame.width/30) }
        [lblDistance,lblPace,lblCalories].forEach { $0.font = UIFont.boldSystemFont(ofSize: frame.width/15) }
        lblDuration.font = UIFont.boldSystemFont(ofSize: frame.width/10)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
