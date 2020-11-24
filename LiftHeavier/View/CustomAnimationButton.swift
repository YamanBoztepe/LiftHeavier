//
//  CustomAnimationButton.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 23.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class CustomAnimationButton: UIButton {
    
    let shapeLayer = CAShapeLayer()
    let circularPath = UIBezierPath()
    let traceLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        traceLayer.path = circularPath.cgPath
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.rgb(red: 0, green: 128, blue: 0).cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        traceLayer.strokeColor = UIColor(white: 0.7, alpha: 0.1).cgColor
        traceLayer.lineWidth = 10
        traceLayer.fillColor = UIColor.rgb(red: 45, green: 45, blue: 45).cgColor
        traceLayer.lineCap = .round
        
        layer.addSublayer(traceLayer)
        layer.addSublayer(shapeLayer)
        
    }
    
    func progressLineBegin() {
        progressAnimation()
    }
    
    fileprivate func progressAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 1.5
        shapeLayer.add(animation, forKey: "animation")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
