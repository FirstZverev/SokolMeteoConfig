//
//  ThriedMeteoData.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 10.08.2020.
//  Copyright © 2020 zverev. All rights reserved.
//
import UIKit
import FittedSheets

class ThriedMeteoData: UIViewController {
    
    var tableView: UITableView!
    var viewModel: TableViewViewModelType?
    var delegate: ThriedConfiguratorDelegate?
    var timer = Timer()
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?

    override func loadView() {
        super.loadView()

    }
    
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .singleLine
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.height(screenH).width(screenW)
        tableView.top(10)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        self.tableView = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sheetViewController?.handleScrollView(self.tableView)
        viewModel = ViewModelData()
        createTableView()
        registerTableView()
        viewShow()
        
    }
    static func instantiate() -> ThriedMeteoData {
        return UIStoryboard(name: "ScrollExample", bundle: nil).instantiateViewController(withIdentifier: "tableViewController") as! ThriedMeteoData
    }
    override func viewDidAppear(_ animated: Bool) {
        timer.invalidate()
        reload = 1
        delegate?.buttonTapThriedConfigurator()
        //        DispatchQueue.main.async { [self] in
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [self] (timer) in
            reload = 1
            delegate?.buttonTapThriedConfigurator()
            self.tableView.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        reload = -1
    }

    private func registerTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(DataCell.self, forCellReuseIdentifier: "DataCell")
    }
    private func viewShow() {
        view.layer.cornerRadius = 35
        view.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.backgroundColor = .white
    }
}

extension ThriedMeteoData: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if indexPath.row == 4 {
//            navigationController?.pushViewController(PasswordController(), animated: true)
//        } else if indexPath.row == 0 {
//            navigationController?.pushViewController(TabBarController(), animated: true)
//        }
    }
}

extension ThriedMeteoData: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as? DataCell
        cell?.selectionStyle = .none
        cell?.labelTwo?.text = "\(arrayStateConnect[indexPath.row])"
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
//        cell = accessoryType(cell: tableViewCell)
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
    
//    func accessoryType(cell: DataCell) -> DataCell {
//        cell.accessoryType = .disclosureIndicator
//        cell.tintColor = .gray
//        let image = UIImage(named:"Arrow")?.withRenderingMode(.alwaysTemplate)
//        if let width = image?.size.width, let height = image?.size.height {
//            let disclosureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//            disclosureImageView.image = image
//            cell.accessoryView = disclosureImageView
//        }
//        return cell
//    }
}

