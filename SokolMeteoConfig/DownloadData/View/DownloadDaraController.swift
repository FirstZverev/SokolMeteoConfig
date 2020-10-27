//
//  DownloadDaraController.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 27.10.2020.
//  Copyright © 2020 zverev. All rights reserved.

import UIKit

class DownloadDaraController: UIViewController {
    
    let customNavigationBar = createCustomNavigationBar(title: "ВЫГРУЖЕННЫЕ ДАННЫЕ",fontSize: screenW / 22)
    var tableView: UITableView!

    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        backView.hero.id = "backView"
        return backView
    }()
    fileprivate lazy var accountButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "account_Image"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .purple
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewDidDisappear(_ animated: Bool) {

    }

    override func loadView() {
        super.loadView()
        createTableView()
        registerTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.sv(
            customNavigationBar, accountButton
        )
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        showView()
    }
    
    func showView() {
        backView.tintColor = .black
        view.addSubview(backView)
        backView.addTapGesture {
            self.navigationController?.popViewController(animated: true)
        }
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavigationBar.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 0).isActive = true
        
        accountButton.bottomAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: -5).isActive = true
        accountButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true

    }
    
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
       // tableView.separatorStyle = .none
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
//        tableView.top(screenH / 12)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.refreshControl = refreshControl
        tableView.sectionHeaderHeight = 50
        self.tableView = tableView
    }
    @objc func refresh(sender:AnyObject) {
        sender.endRefreshing()
    }
    
}

extension DownloadDaraController: UITableViewDelegate, UITableViewDataSource {
    
    private func registerTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(CellMain.self, forCellReuseIdentifier: "CellMain")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayBmvdE[section].count + 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        arrayBmvdE.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMain", for: indexPath) as? CellMain
        cell?.deviceName?.text = "Sokol-M_348"
        cell?.dateLabel?.text = "10.01.2020-20.01.2020"
        if indexPath.section == 0 {
            cell?.stateLabel?.text = "В процессе"
            cell?.timeLabel?.text =  "07:14"
            cell?.stateLabel?.textColor = UIColor(rgb: 0xF7B801)
            cell?.imageUI?.image = UIImage(named: "restoreData")
        } else {
            cell?.stateLabel?.text = "Отправлено"
            cell?.timeLabel?.text =  "23:59"
            cell?.stateLabel?.textColor = UIColor(rgb: 0x01AC5A)
            cell?.imageUI?.image = UIImage(named: "doneData")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UIButton()
        label.setTitle(" \(10 - section) Октября ", for: .normal)
        label.titleLabel?.numberOfLines = 0
        if section == 0 {
            label.backgroundColor = UIColor(rgb: 0xBE449E)
        } else {
            label.backgroundColor = UIColor(rgb: 0xD4D4D4)
        }
        label.layer.cornerRadius = 15
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: screenW / 3).isActive = true
        return headerView
    }
}
