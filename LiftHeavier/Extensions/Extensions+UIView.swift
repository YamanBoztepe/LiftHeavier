//
//  Extensions+UIView.swift
//  LiftBetter
//
//  Created by Yaman Boztepe on 16.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

struct AnchorConstraint {
    
    var top : NSLayoutConstraint?
    var bottom : NSLayoutConstraint?
    var leading : NSLayoutConstraint?
    var trailing : NSLayoutConstraint?
    var width : NSLayoutConstraint?
    var height : NSLayoutConstraint?
}

extension UIColor {
    
    static func rgb(red : CGFloat, green : CGFloat, blue : CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    
    func anchor(top : NSLayoutYAxisAnchor?, bottom : NSLayoutYAxisAnchor?, leading : NSLayoutXAxisAnchor?, trailing : NSLayoutXAxisAnchor?, padding : UIEdgeInsets = .zero, size : CGSize = .zero) -> AnchorConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchorConstraint = AnchorConstraint()
        
        if let top = top {
            
            anchorConstraint.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let bottom = bottom {
            
            anchorConstraint.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let leading = leading {
            
            anchorConstraint.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let trailing = trailing {
            
            anchorConstraint.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchorConstraint.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchorConstraint.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchorConstraint.top,anchorConstraint.bottom,anchorConstraint.leading,anchorConstraint.trailing,anchorConstraint.width,anchorConstraint.height].forEach { $0?.isActive = true}
        
        return anchorConstraint
    }
    
    
    func positionInCenterSuperView(size : CGSize = .zero,centerX : NSLayoutXAxisAnchor?,centerY : NSLayoutYAxisAnchor?) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
    
    func setShadow(opacity : Float,radius : CGFloat,offSet : CGSize = .zero,color : UIColor) {
        
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offSet
        layer.shadowColor = color.cgColor
        
    }
    
    
    func keyboardShowObserverForWSC() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(buttonUp(_ :)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func buttonUp(_ notification : NSNotification){
        
        let time = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        
        let startFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let distanceY = endFrame.origin.y - startFrame.origin.y
        
        UIButton.animateKeyframes(withDuration: time, delay: 0.0, options: UIView.KeyframeAnimationOptions.init(rawValue: curve), animations: {
            
            self.frame.origin.y += distanceY/1.8
            
        }) { (_) in
            
            
        }
        
    }
    
    func keyboardShowObserverForWBC() {
        NotificationCenter.default.addObserver(self, selector: #selector(buttonChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func buttonChange(_ notification : NSNotification) {
        
        let time = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        
        let startFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let distanceY = endFrame.origin.y - startFrame.origin.y
        
        UIButton.animateKeyframes(withDuration: time, delay: 0.0, options: .init(rawValue: curve), animations: {
            self.frame.origin.y += distanceY
        }, completion: nil)
    }
    
    func setRotationAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = NSNumber(value: -Double.pi/12)
        rotation.toValue = NSNumber(value: Double.pi/12)
        rotation.duration = 0.5
        rotation.repeatCount = Float.infinity
        rotation.autoreverses = true
        self.layer.add(rotation, forKey: "rotationAnimation")
        
    }
    
}

