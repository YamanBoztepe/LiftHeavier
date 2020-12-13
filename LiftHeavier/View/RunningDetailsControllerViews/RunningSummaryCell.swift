//
//  RunningSummaryCell.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 11.12.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class RunningSummaryCell: UITableViewCell {
    
    static let IDENTIFIER = "RunningSummarCell"
    
    fileprivate let totalView = UIView()
    
    fileprivate let lblAveragePaceText: UILabel = {
        let lbl = UILabel()
        lbl.text = AVG_PACE
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
    let lblAveragePace: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.text = "00:00"
        return lbl
    }()
    
    fileprivate let averagePaceStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 3
        sv.alignment = .center
        sv.distribution = .fillEqually
        return sv
    }()
    
    fileprivate let lblDistance: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = .white
        lbl.text = "10.99 mil"
        return lbl
    }()
    
    fileprivate let lblDuration: UILabel = {
       let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.textColor = .white
        lbl.text = "00:00:00"
        return lbl
    }()
    
    fileprivate let lblDate: UILabel = {
       let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.textColor = .white
        lbl.text = "12/10/2021"
        return lbl
    }()
    
    fileprivate let lblCalories: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = .white
        return lbl
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    
    fileprivate func setLayout() {
        selectionStyle = .none
        backgroundColor = .clear
        totalView.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        [lblAveragePaceText,lblAveragePace].forEach { averagePaceStackView.addArrangedSubview($0) }
        [averagePaceStackView,lblDistance,lblDuration,lblDate,lblCalories].forEach { totalView.addSubview($0) }
        addSubview(totalView)
        
        _ = totalView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor,padding: .init(top: frame.height/7, left: frame.height/7, bottom: frame.height/7, right: frame.height/7))
        _ = lblDistance.anchor(top: totalView.topAnchor, bottom: nil, leading: totalView.leadingAnchor, trailing: nil,padding: .init(top: frame.height/7, left: frame.height/7, bottom: 0, right: 0),size: .init(width: frame.width/3, height: frame.height/1.8))
        _ = lblDuration.anchor(top: totalView.topAnchor, bottom: nil, leading: nil, trailing: totalView.trailingAnchor,padding: .init(top: frame.height/7, left: 0, bottom: 0, right: frame.height/7),size: .init(width: frame.width/3, height: frame.height/1.8))
        _ = lblDate.anchor(top: nil, bottom: totalView.bottomAnchor, leading: nil, trailing: totalView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: frame.height/7, right: frame.height/7),size: .init(width: frame.width/3, height: frame.height/1.8))
        _ = lblCalories.anchor(top: nil, bottom: totalView.bottomAnchor, leading: totalView.leadingAnchor, trailing: nil,padding: .init(top: 0, left: frame.height/7, bottom: frame.height/7, right: 0),size: .init(width: frame.width/3, height: frame.height/1.8))
        
        averagePaceStackView.positionInCenterSuperView(size: .init(width: frame.width/3, height: 0), centerX: centerXAnchor, centerY: centerYAnchor)
        
        
        [lblAveragePaceText].forEach { $0.font = UIFont.boldSystemFont(ofSize: frame.width/25) }
        [lblAveragePace,lblDistance,lblDuration,lblDate].forEach { $0.font = UIFont.systemFont(ofSize: frame.width/20) }
        
    }
    
    
    func setData(pace: Int, distance: Double, duration: Int,date: NSDate,calories: Int) {
        
        lblAveragePace.text = "\(pace.translateSecondToDuration())"
        lblDuration.text = "\(duration.translateSecondToDuration()) min"
        lblDistance.text = "\(String(format: "%.3f", distance/1609.344)) mil"
        lblDate.text = date.getDate()
        
        if calories == 0 {
            lblCalories.isHidden = true
        } else {
            lblCalories.isHidden = false
            lblCalories.text = "\(calories) cal"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
