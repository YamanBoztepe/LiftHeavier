//
//  AddWorkoutCell.swift
//  LiftBetter
//
//  Created by Yaman Boztepe on 19.10.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class AddWorkoutCell: UITableViewCell {

    static let IDENTIFIER : String = "AddWorkoutCell"
    
    let txtExerciseName : UILabel = {
        let lbl = UILabel()
        lbl.text = EXERCISE_NAME
        lbl.textColor = .white
        return lbl
    }()
    
    let txtSetsOfExercise : UILabel = {
        let lbl = UILabel()
        lbl.text = SET_NUMBERS
        lbl.textColor = .white
        return lbl
    }()
    
    let topStackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()
    
    let bottomStackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    
    let txtExerciseField : TextFieldInsets = {
        let txt = TextFieldInsets()
        txt.isUserInteractionEnabled = false
        return txt
    }()
    
    let txtSetField : TextFieldInsets = {
        let txt = TextFieldInsets()
        txt.isUserInteractionEnabled = false
        return txt
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    fileprivate func setLayout() {
        
        backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
       
        [txtExerciseName,txtExerciseField].forEach { topStackView.addArrangedSubview($0) }
        [txtSetsOfExercise,txtSetField].forEach { bottomStackView.addArrangedSubview($0) }
        [topStackView,bottomStackView].forEach { addSubview($0) }
        
        _ = topStackView.anchor(top: topAnchor, bottom: bottomStackView.topAnchor, leading: leadingAnchor, trailing: trailingAnchor,padding: .init(top: frame.height/10, left: frame.width/20, bottom: 0, right: frame.width/20))
       
        _ = txtExerciseName.anchor(top: nil, bottom: nil, leading: topStackView.leadingAnchor, trailing: txtSetsOfExercise.trailingAnchor)
       
        _ = txtExerciseField.anchor(top: nil, bottom: nil, leading: txtExerciseName.trailingAnchor, trailing: topStackView.trailingAnchor)
       
        _ = bottomStackView.anchor(top: topStackView.bottomAnchor, bottom: bottomAnchor, leading: topStackView.leadingAnchor, trailing: topStackView.trailingAnchor)
       
        _ = txtSetsOfExercise.anchor(top: nil, bottom: nil, leading: bottomStackView.leadingAnchor, trailing: nil)
        
        _ = txtSetField.anchor(top: nil, bottom: nil, leading: txtSetsOfExercise.trailingAnchor, trailing: bottomStackView.trailingAnchor)
        
        [txtExerciseName,txtSetsOfExercise].forEach { $0.font = UIFont.boldSystemFont(ofSize: frame.width/35) }
    }
    
 
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
