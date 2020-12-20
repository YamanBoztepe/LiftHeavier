//
//  ShowDetailsController.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 21.12.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit

class ShowDetailsController: RunningDetailsController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setLayout() {
        super.setLayout()
        continueButton.removeFromSuperview()
        _ = tableView.anchor(top: topView.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: view.frame.height/50, right: 0))
    }
    
    override func continueButtonPressed() {
        navigationController?.view.layer.add(CATransition().fromTopToBottom(), forKey: nil)
        navigationController?.popViewController(animated: false)
    }
}
