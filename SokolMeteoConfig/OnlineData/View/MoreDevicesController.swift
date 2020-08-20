//
//  MoreDevicesController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 25.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class MoreDevicesController: UIViewController {
    
    
    var tableView: UITableView!
    var viewModel: TableViewViewModelType?

    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        return backView
    }()
    
    fileprivate lazy var nextRegBMVD: UIButton = {
        var btn = UIButton()
        btn.backgroundColor = .red
        btn.layer.cornerRadius = 20
        btn.titleLabel?.font = UIFont(name: "FuturaPT-Medium", size: 18)
        btn.setTitle("Регистрация БМВД", for: .normal)
        return btn
    }()
    override func loadView() {
        super.loadView()
        createTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        registerTableView()
        viewModel = ViewModelMoreDevices()
        let customNavigationBar = createCustomNavigationBar(title: "ДОП.УСТРОЙСТВА",fontSize: 16.0)
        self.hero.isEnabled = true
        view.sv(customNavigationBar,nextRegBMVD)
        createRegBMVD()
        showView()
    }
    fileprivate func createRegBMVD() {
        nextRegBMVD.height(43).width(screenW / 1.5).centerHorizontally().top(240)
    }
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .singleLine
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.height(140).width(screenW)
        tableView.top(80)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        self.tableView = tableView
    }
    
    private func registerTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(StateCell.self, forCellReuseIdentifier: "StateCell")
    }
    func showView() {
        backView.tintColor = .black
        view.addSubview(backView)
        
        backView.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension MoreDevicesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("1")
        } else if indexPath.row == 1 {
            print("2")
        }
    }
}

extension MoreDevicesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StateCell", for: indexPath) as? StateCell
        if indexPath.row == 4 {
            cell!.hero.id = "MeteoDataToMeteo"
        } else if indexPath.row == 0 {

        }
        cell?.selectionStyle = .none
        cell?.imageUI?.image = UIImage(named: "moreDevices")
        cell?.labelTwo?.text = ""
        cell?.accessoryType = .disclosureIndicator
        cell?.tintColor = .gray
        let image = UIImage(named:"Arrow")?.withRenderingMode(.alwaysTemplate)
        if let width = image?.size.width, let height = image?.size.height {
            let disclosureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            disclosureImageView.image = image
            cell?.accessoryView = disclosureImageView
        }
//        cell?.labelTwo?.text = "\(arrayMeteo[indexPath.row])"
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
}
