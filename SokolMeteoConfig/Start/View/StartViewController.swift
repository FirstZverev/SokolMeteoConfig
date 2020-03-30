//
//  ViewController.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 26.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import Hero

class StartViewController: UIViewController {

    var tableView: UITableView!
    var viewModel: TableViewViewModelType?
    
    lazy var greenView: UIView = {
        let v = UIView()
        v.backgroundColor = .green
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        viewModel = ViewModel()
        
        self.hero.isEnabled = true
        greenView.hero.id = "greenView"
        
        view.backgroundColor = .blue
        
        greenView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(popVC)))

//        view.sv(
//            greenView
//        )
//        
//        greenView.height(150).width(150).centerHorizontally().centerVertically(300)
    }
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func registerTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0),
        ])
        tableView.showsVerticalScrollIndicator = false
        self.tableView = tableView
    }
    
    override func loadView() {
        super.loadView()
        createTableView()
        
    }

}

extension StartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            navigationController?.pushViewController(ListOfAvailableMeteoController(), animated: true)
        }
    }
}

extension StartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell
        
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
}

