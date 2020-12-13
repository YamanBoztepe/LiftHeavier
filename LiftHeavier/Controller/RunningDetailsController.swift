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
    
    fileprivate let lblInfoMessage: UILabel = {
        let lbl = UILabel()
        lbl.text = INFO_MESSAGE
        lbl.textColor = .gray
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    fileprivate let extraView = UIView()
    fileprivate let topView = TopViewCancelButton()
    
    fileprivate let tableView = UITableView()
    fileprivate let continueButton = CustomSaveButton()
    
    fileprivate var calories = 0
    fileprivate var bmr = 0.0
    
    fileprivate let realm = try! Realm()
    fileprivate var runningSummaryList: Results<RunningSummayModel>? {
        didSet {
            if let summaryList = runningSummaryList {
                lblInfoMessage.isHidden = summaryList.count>1
            }
        }
    }
    
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
    
    fileprivate func setLayout() {
        view.backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        extraView.backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        tableView.backgroundColor = .clear
        
        [extraView,topView,tableView,continueButton,lblInfoMessage].forEach { view.addSubview($0) }
        
        _ = extraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/15))
        _ = tableView.anchor(top: topView.bottomAnchor, bottom: continueButton.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: view.frame.height/50, right: 0))
        _ = continueButton.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: nil,padding: .init(top: 0, left: 0, bottom: view.frame.height/50, right: 0),size: .init(width: view.frame.width/2.5, height: view.frame.height/20))
        _ = lblInfoMessage.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        lblInfoMessage.positionInCenterSuperView(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
        lblInfoMessage.font = UIFont.boldSystemFont(ofSize: view.frame.width/15)
        
        continueButton.positionInCenterSuperView(centerX: view.centerXAnchor, centerY: nil)
        continueButton.buttonTitle.text = CONTINUE_BUTTON
        continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        
        topView.personalDetailButton.addTarget(self, action: #selector(personalDetailPressed), for: .touchUpInside)
        topView.backButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
    }
    
    fileprivate func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(RunningSummaryCell.self, forCellReuseIdentifier: RunningSummaryCell.IDENTIFIER)
    }
    
    fileprivate func calculateCalories(pace: Int, duration: Int) -> Int {
        guard let personalDetail = realm.objects(PersonalDetails.self).first else { return 0 }
        
        if personalDetail.isMale {
            bmr = 10 * personalDetail.weight + 6.25 * personalDetail.height - 5 * Double(personalDetail.age) - 161
            
        } else {
            bmr = 10 * personalDetail.weight + 6.25 * personalDetail.height - 5 * Double(personalDetail.age) + 5
        }
        
        let mph = 60/(pace.translateIntToSecond())
        let metValue = getMetValue(mph: round(mph))
        
        
        calories = Int(((bmr/24) * metValue) * (duration.translateIntToSecond())/60)
        return calories
    }
    
    fileprivate func getMetValue(mph: Double) -> Double {
        var metValue = 0.0
        switch mph {
        case 4:
            metValue = 6
        case 5:
            metValue = 8.3
        case 6:
            metValue = 9.8
        case 7:
            metValue = 11
        case 8:
            metValue = 11.8
        case 9:
            metValue = 12.8
        case 10:
            metValue = 14.5
        case 11:
            metValue = 16
        case 12:
            metValue = 19
        case 13:
            metValue = 19.8
        case 14:
            metValue = 23
        default:
            metValue = 13
        }
        return metValue
    }
    
    @objc fileprivate func continueButtonPressed() {
        navigationController?.view.layer.add(CATransition().fromLeftToRight(), forKey: nil)
        navigationController?.popToRootViewController(animated: false)
    }
    @objc fileprivate func personalDetailPressed() {
        let vc = PersonalDetailsController()
        navigationController?.pushViewController(vc, animated: false)
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
        let currentCalories = calculateCalories(pace: summaryInfo.avgPace, duration: summaryInfo.duration)
        
        cell.setData(pace: summaryInfo.avgPace, distance: summaryInfo.distance, duration: summaryInfo.duration, date: summaryInfo.date, calories: currentCalories)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return view.frame.height/5
        }
        return view.frame.height/8
    }
}
