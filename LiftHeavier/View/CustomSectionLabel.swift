//
//  CustomSectionView.swift
//  LiftBetter
//
//  Created by Yaman Boztepe on 19.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class CustomSectionLabel : UIView {
    
    var sectionName : UILabel = {
       let lbl = UILabel()
        lbl.textColor = .white
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    override func draw(_ rect: CGRect) {
        
        let cornerRad = rect.height / 2
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColor.green.cgColor,UIColor.rgb(red: 0, green: 128, blue: 0).cgColor,UIColor.rgb(red: 18, green: 53, blue: 36).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let maskLayer = CAShapeLayer()
        let maskPath = CGMutablePath()
        
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRad).cgPath)
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerRadius: cornerRad).cgPath)
        
        maskLayer.fillRule = .evenOdd
        maskLayer.path = maskPath
        
        gradientLayer.mask = maskLayer
        
        layer.addSublayer(gradientLayer)
        layer.cornerRadius = cornerRad
        gradientLayer.frame = rect
    }
    
    fileprivate func setLayout() {
        addSubview(sectionName)
        _ = sectionName.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil,padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        sectionName.font = UIFont.boldSystemFont(ofSize: frame.width/25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
