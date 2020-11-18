//
//  StatisticsController.swift
//  LiftHeavier
//
//  Created by Yaman Boztepe on 8.11.2020.
//  Copyright © 2020 Yaman Boztepe. All rights reserved.
//

import UIKit
import RealmSwift

class StatisticsController: UIViewController {

    let realm = try! Realm()
    var windowSettingsList : Results<WindowSettingsModel>? {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate let extraTopView = UIView()
    fileprivate let topView = TopViewOfSC()
    fileprivate let bottomView = BottomViewOfSC()
    fileprivate let extraBottomView = UIView()
    
    fileprivate let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        windowSettingsList = realm.objects(WindowSettingsModel.self)
    }

    fileprivate func setLayout() {
        
        view.backgroundColor = UIColor.rgb(red: 45, green: 45, blue: 45)
        extraTopView.backgroundColor = UIColor.rgb(red: 23, green: 23, blue: 23)
        extraBottomView.backgroundColor = bottomView.backgroundColor
        tableView.backgroundColor = view.backgroundColor
        
        [extraTopView,topView,tableView,bottomView,extraBottomView].forEach { view.addSubview($0) }
        
        _ = extraTopView.anchor(top: view.topAnchor, bottom: topView.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: view.frame.height/17))
        _ = tableView.anchor(top: topView.bottomAnchor, bottom: bottomView.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        _ = bottomView.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: view.frame.height/15))
        _ = extraBottomView.anchor(top: bottomView.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        bottomView.mainViewButton.addTarget(self, action: #selector(mainViewButtonPressed), for: .touchUpInside)
    }
    
    fileprivate func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WindowTableCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    fileprivate func fetchDataForCell(_ indexPath: IndexPath, _ cell: WindowTableCell) {
        if let windowCell = windowSettingsList?[indexPath.row] {
            cell.lblText.text = windowCell.windowName
            switch windowCell.windowColorText {
            case "blue":
                cell.mainView.backgroundColor = .rgb(red: 0, green: 0, blue: 255)
            case "red":
                cell.mainView.backgroundColor = .rgb(red: 255, green: 0, blue: 0)
            case "green":
                cell.mainView.backgroundColor = .rgb(red: 0, green: 128, blue: 0)
            case "purple":
                cell.mainView.backgroundColor = .rgb(red: 128, green: 0, blue: 128)
            case "yellow":
                cell.mainView.backgroundColor = .rgb(red: 255, green: 215, blue: 0)
            case "pink":
                cell.mainView.backgroundColor = .rgb(red: 255, green: 0, blue: 255)
            default:
                cell.mainView.backgroundColor = .rgb(red: 0, green: 0, blue: 255)
            }
        }
    }
    
    @objc fileprivate func mainViewButtonPressed() {
        navigationController?.popViewController(animated: false)
    }
}


extension StatisticsController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        windowSettingsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? WindowTableCell else { return UITableViewCell() }
        
        fetchDataForCell(indexPath, cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedWindow = windowSettingsList?[indexPath.row] else { return }
        let vc = WorkoutStatisticController()
        vc.windowSettingsList = selectedWindow
        navigationController?.pushViewController(vc, animated: true)
    }
}
