//
//  MoreDetailsController.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 18.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class MoreDetailsController: UIViewController {
    
    fileprivate let extraView = UIView()
    fileprivate let topView = TopViewWithBackButton()
    fileprivate let tableView = UITableView()
    
    var selectedExerciseDates = List<ExerciseDate>()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedExerciseDates)
        setLayout()
        setTableView()
    }
    
    fileprivate func setLayout() {
        view.backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        extraView.backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        tableView.backgroundColor = .clear
        [extraView,topView,tableView].forEach { view.addSubview($0) }
        
        _ = extraView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,size: .init(width: 0, height: view.frame.height/15))
        _ = tableView.anchor(top: topView.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        topView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    fileprivate func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WorkoutInfoCell.self, forCellReuseIdentifier: WorkoutInfoCell.IDENTIFIER)
    }
    
    @objc fileprivate func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

}

extension MoreDetailsController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedExerciseDates[section].exerciseDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutInfoCell.IDENTIFIER, for: indexPath) as? WorkoutInfoCell else { return WorkoutInfoCell() }
        
        let exerciseDetail = selectedExerciseDates[indexPath.section].exerciseDetails[indexPath.row]
        
        cell.numberOfSet = exerciseDetail.numberOfSet
        cell.liftedWeight = exerciseDetail.liftedWeight
        cell.reps = exerciseDetail.reps
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/8
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedExerciseDates.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let contentView = UIView()
        let lblTitle : UILabel = {
            let lbl = UILabel()
            lbl.text = String(selectedExerciseDates[section].date.prefix(10))
            lbl.textColor = .white
            lbl.textAlignment = .center
            lbl.backgroundColor = .clear
            lbl.font = UIFont.boldSystemFont(ofSize: view.frame.width/20)
            return lbl
        }()
        contentView.addSubview(lblTitle)
        _ = lblTitle.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor,padding: .init(top: view.frame.height/30, left: 0, bottom: view.frame.height/30, right: 0))
        return contentView
    }
    
}
