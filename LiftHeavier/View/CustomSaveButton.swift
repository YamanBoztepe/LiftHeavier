//
//  CustomSaveButton.swift
//  LiftBetter
//
//  Created by Yaman Boztepe on 19.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class CustomSaveButton : UIButton {
    
    let buttonTitle : UILabel = {
        let txt = UILabel()
        txt.text = BUTTON_TEXT
        txt.textColor = .white
        return txt
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    fileprivate func setLayout() {
        
        setShadow(opacity: 1, radius: 2, offSet: .init(width: 0, height: 10), color: .black)
        addSubview(buttonTitle)
        
        buttonTitle.positionInCenterSuperView(centerX: centerXAnchor, centerY: centerYAnchor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buttonTitle.font = UIFont.boldSystemFont(ofSize: frame.width/10)
    }
    
    override func draw(_ rect: CGRect) {
        
        let cornerRad = rect.height / 2
        
        let gradientLayer = CAGradientLayer()
        
        if self.isEnabled {
            gradientLayer.colors = [UIColor.green.cgColor,UIColor.rgb(red: 0, green: 128, blue: 0).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        }else {
            gradientLayer.colors = [UIColor.red.cgColor,UIColor.red.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        }
        
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
