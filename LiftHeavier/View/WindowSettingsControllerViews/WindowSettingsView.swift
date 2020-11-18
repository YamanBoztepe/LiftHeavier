//
//  WindowSettingView.swift
//  LiftBetter
//
//  Created by Yaman Boztepe on 19.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class WindowSettingsView : UIView {
    
    let stackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .center
        return sv
    }()
    
    let lblText : UILabel = {
        let lbl = UILabel()
        lbl.text = WINDOW_NAME
        lbl.textColor = .white
        return lbl
    }()
    
    let txtField = TextFieldInsets()
    
    let lblText2 : UILabel = {
        let lbl = UILabel()
        lbl.text = WINDOW_COLOR
        lbl.textColor = .white
        return lbl
    }()
    
    var selectedColor : UIColor? {
        didSet {
            for button in btnList {
                
                if button.backgroundColor == selectedColor {
                    continue
                }else {
                    button.layer.borderWidth = 0
                }
            }
        }
    }
    var selectedColorText : String?
    
    let colorViews : UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        return view
    }()
    
    let btnBlue : UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = "blue"
        btn.titleLabel?.isHidden = true
        btn.backgroundColor = .rgb(red: 0, green: 0, blue: 255)
        return btn
    }()
    
    let btnRed : UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = "red"
        btn.titleLabel?.isHidden = true
        btn.backgroundColor = .rgb(red: 255, green: 0, blue: 0)
        return btn
    }()
    
    let btnGreen : UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = "green"
        btn.titleLabel?.isHidden = true
        btn.backgroundColor = .rgb(red: 0, green: 128, blue: 0)
        return btn
    }()
    
    let btnYellow : UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = "yellow"
        btn.titleLabel?.isHidden = true
        btn.backgroundColor = .rgb(red: 255, green: 215, blue: 0)
        return btn
    }()
    
    let btnPurple : UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = "purple"
        btn.titleLabel?.isHidden = true
        btn.backgroundColor = .rgb(red: 128, green: 0, blue: 128)
        return btn
    }()
    
    let btnPink : UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = "pink"
        btn.titleLabel?.isHidden = true
        btn.backgroundColor = .rgb(red: 255, green: 0, blue: 255)
        return btn
    }()
    
   
    var btnList = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        btnList = [btnBlue,btnRed,btnGreen,btnPurple,btnYellow,btnPink]
        btnList.forEach { $0.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)}
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    fileprivate func setLayout() {
        addSubview(stackView)
        btnList.forEach { colorViews.addSubview($0)}
        [lblText,txtField,lblText2,colorViews].forEach { stackView.addArrangedSubview($0) }
        addSubview(stackView)
        
        _ = stackView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        _ = lblText.anchor(top: stackView.topAnchor, bottom: nil, leading: stackView.leadingAnchor, trailing: nil,padding: .init(top: 0, left: frame.width/30, bottom: 0, right: 0))
        _ = txtField.anchor(top: lblText.bottomAnchor, bottom: nil, leading: lblText.leadingAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        _ = lblText2.anchor(top: txtField.bottomAnchor, bottom: colorViews.topAnchor, leading: lblText.leadingAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        _ = colorViews.anchor(top: lblText2.bottomAnchor, bottom: stackView.bottomAnchor, leading: lblText.leadingAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        [lblText,lblText2].forEach { $0.font = UIFont.boldSystemFont(ofSize: frame.width/30) }
        
        //Constraints for color buttons
        _ = btnBlue.anchor(top: colorViews.topAnchor, bottom: nil, leading: colorViews.leadingAnchor, trailing: nil,padding: .init(top: 1, left: 1, bottom: 1, right: 0),size: .init(width: 0, height: 0))
        _ = btnRed.anchor(top: colorViews.topAnchor, bottom: nil, leading: btnBlue.trailingAnchor, trailing: nil,padding: .init(top: 1, left: 4, bottom: 1, right: 0),size: .init(width: 0, height: 0))
        _ = btnGreen.anchor(top: colorViews.topAnchor, bottom: nil, leading: btnRed.trailingAnchor, trailing: nil,padding: .init(top: 1, left: 4, bottom: 1, right: 0),size: .init(width: 0, height: 0))
        _ = btnPurple.anchor(top: colorViews.topAnchor, bottom: nil, leading: btnGreen.trailingAnchor, trailing: nil,padding: .init(top: 1, left: 4, bottom: 1, right: 0),size: .init(width: 0, height: 0))
        _ = btnYellow.anchor(top: colorViews.topAnchor, bottom: nil, leading: btnPurple.trailingAnchor, trailing: nil,padding: .init(top: 1, left: 4, bottom: 1, right: 0),size: .init(width: 0, height: 0))
        _ = btnPink.anchor(top: colorViews.topAnchor, bottom: nil, leading: btnYellow.trailingAnchor, trailing: nil,padding: .init(top: 1, left: 4, bottom: 1, right: 0),size: .init(width: 0, height: 0))
        
        btnList.forEach { $0.layer.cornerRadius = 10}
    }
    
    
    @objc fileprivate func btnPressed(btn : UIButton) {
        
        selectedColor = btn.backgroundColor!
        selectedColorText = btn.titleLabel?.text ?? ""
        btn.layer.borderWidth = 5
        btn.layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

