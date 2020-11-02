//
//  BlackBoxTableView.swift
//  SOKOL-M
//
//  Created by Володя Зверев on 06.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

extension BlackBoxTable: UITableViewDelegate, UITableViewDataSource {
    
    func registerTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(BlackBoxTableViewCell.self, forCellReuseIdentifier: "BlackBoxTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewAlpha.isHidden = true
        return timeHour.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlackBoxTableViewCell", for: indexPath) as? BlackBoxTableViewCell
        cell?.selectionStyle = .none
        cell?.label?.text = timeHour[indexPath.row]
        cell?.imageUI?.image = UIImage(named: "timeBlackBox")
        
        cell?.labelTwo?.text = valueParametrs[indexPath.row]
//        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
//        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
//        tableViewCell.viewModel = cellViewModel

        return cell!
    }
    
    
}
