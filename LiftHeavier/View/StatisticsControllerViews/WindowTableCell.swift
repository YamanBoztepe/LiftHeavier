//
//  TableViewCell.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 8.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class WindowTableCell: UITableViewCell {
    
    let mainView = UIView()
    let lblText = UILabel()
    fileprivate let gradientLayer = CAGradientLayer()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    fileprivate func setLayout() {
        selectionStyle = .none
        backgroundColor = .clear
        
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = frame.width/17
        lblText.font = UIFont.boldSystemFont(ofSize: frame.width/20)
        lblText.textColor = .white
        
        mainView.addSubview(lblText)
        addSubview(mainView)
        _ = mainView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor,padding: .init(top: frame.width/30, left: frame.width/40, bottom: frame.width/30, right: frame.width/40))
        _ = lblText.anchor(top: nil, bottom: nil, leading: mainView.leadingAnchor, trailing: nil,padding: .init(top: 0, left: frame.width/20, bottom: 0, right: 0))
        lblText.positionInCenterSuperView(centerX: nil, centerY: mainView.centerYAnchor)
        setGradientLayer()
    }
    
    fileprivate func setGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0.4,1.5]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        mainView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = mainView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
