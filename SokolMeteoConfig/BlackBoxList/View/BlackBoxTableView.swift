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
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlackBoxTableViewCell", for: indexPath) as? BlackBoxTableViewCell
        cell?.selectionStyle = .none
        cell?.labelTwo?.text = "\(indexPath.row) м/c"
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel

        return tableViewCell
    }
    
    
}
