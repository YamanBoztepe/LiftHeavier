//
//  LastRunningSummary.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 11.12.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class LastRunningSummary: UIView {
    
    fileprivate let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.text = LAST_RUN_TITLE
        lbl.textAlignment = .left
        return lbl
    }()
    
    let lblAveragePace: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.text = AVERAGE_PACE
        return lbl
    }()
    
    let lblDistance: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.text = DISTANCE2
        return lbl
    }()
    
    let lblDuration: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.text = DURATION
        return lbl
    }()
    
    let totalStackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .leading
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 3
        return sv
    }()
    
    let closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    fileprivate func setLayout() {
        backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        [lblAveragePace,lblDistance,lblDuration].forEach { totalStackView.addArrangedSubview($0) }
        [lblTitle,closeButton,totalStackView].forEach { addSubview($0) }
        
        _ = lblTitle.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: closeButton.leadingAnchor,padding: .init(top: 0, left: 5, bottom: 0, right: 0),size: .init(width: 0, height: frame.height/3))
        _ = totalStackView.anchor(top: lblTitle.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: closeButton.leadingAnchor,padding: .init(top: 0, left: 5, bottom: 5, right: 0))
        _ = closeButton.anchor(top: nil, bottom: nil, leading: nil, trailing: trailingAnchor,size: .init(width: frame.width/5, height: 0))
        
        closeButton.positionInCenterSuperView(centerX: nil, centerY: centerYAnchor)
        
        lblTitle.font = UIFont.boldSystemFont(ofSize: frame.width/20)
        [lblDuration,lblDistance,lblAveragePace].forEach { $0.font = UIFont.systemFont(ofSize: frame.width/25) }
    }
    
    func setData(averagePace: Int, distance: Double, duration: Int) {
        self.lblDuration.text! += duration.translateSecondToDuration()
        self.lblDistance.text! += String(format: "%.2f", distance/1609.344)
        self.lblAveragePace.text! += averagePace.translateSecondToDuration()
    }
    
}
