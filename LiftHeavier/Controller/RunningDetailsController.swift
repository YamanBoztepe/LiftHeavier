//
//  RunningDetailsController.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 11.12.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class RunningDetailsController: UIViewController {
    
    fileprivate let extraView = UIView()
    let topView = TopViewCancelButton()
    
    let tableView = UITableView()
    let continueButton = CustomSaveButton()
    
    fileprivate let realm = try! Realm()
    fileprivate var runningSummaryList: Results<RunningSummayModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runningSummaryList = RunningSummayModel.fetchRunningSummaries()
        setLayout()
    }
    
    func setLayout() {
        view.backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        extraView.backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        tableView.backgroundColor = .clear
        
        [extraView,topView,tableView,continueButton].forEach { view.addSubview($0) }
        
        _ = extraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/15))
        _ = tableView.anchor(top: topView.bottomAnchor, bottom: continueButton.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: view.frame.height/50, right: 0))
        _ = continueButton.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: nil,padding: .init(top: 0, left: 0, bottom: view.frame.height/50, right: 0),size: .init(width: view.frame.width/2.5, height: view.frame.height/20))
        
        continueButton.positionInCenterSuperView(centerX: view.centerXAnchor, centerY: nil)
        continueButton.buttonTitle.text = CONTINUE_BUTTON
        continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        
        topView.backButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
    }
    
    fileprivate func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(RunningSummaryCell.self, forCellReuseIdentifier: RunningSummaryCell.IDENTIFIER)
    }
    
    
    @objc func continueButtonPressed() {
        navigationController?.view.layer.add(CATransition().fromLeftToRight(), forKey: nil)
        navigationController?.popToRootViewController(animated: false)
    }

}

extension RunningDetailsController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let summaryList = runningSummaryList {
            return summaryList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RunningSummaryCell.IDENTIFIER, for: indexPath) as? RunningSummaryCell else { return UITableViewCell() }
        
        guard let summaryInfo = runningSummaryList?[indexPath.row] else { return UITableViewCell()}
        
        cell.setData(pace: summaryInfo.avgPace, distance: summaryInfo.distance, duration: summaryInfo.duration, date: summaryInfo.date, calories: summaryInfo.calories)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return view.frame.height/5
        }
        return view.frame.height/8
    }
}
