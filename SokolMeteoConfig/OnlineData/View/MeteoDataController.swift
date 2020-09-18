//
//  MeteoData.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 25.05.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class MeteoDataController: UIViewController {
    
    var tableView: UITableView!
    var viewModel: TableViewViewModelType?
    var timer = Timer()
    var delegate: MeteoDelegate?
    let customNavigationBar = createCustomNavigationBar(title: "МЕТЕО ДАННЫЕ",fontSize: 16.0)
    var indexPathCounst: IndexPath?
    
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
    fileprivate lazy var saveButton: UIImageView = {
        let saveButton = UIImageView(image: UIImage(named: "imgPushBar"))
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        return saveButton
    }()
    
    fileprivate lazy var save2Button: UIImageView = {
        let saveButton = UIImageView(image: UIImage(named: "imgSaveBar"))
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        return saveButton
    }()
    
    fileprivate lazy var save3Button: UIImageView = {
        let saveButton = UIImageView(image: UIImage(named: "imgDeleteBar"))
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        return saveButton
    }()
    
    override func loadView() {
        super.loadView()
        createTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reload = 2
        delegate?.buttonTapMeteo()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.tableView.reloadData()
        })
        timer =  Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { (timer) in
            self.delegate?.buttonTapMeteo()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        reload = -1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        registerTableView()
        
        viewModel = ViewModelMeteoData()
        self.hero.isEnabled = true
        customNavigationBar.hero.id = "OnlineToMeteo"


        view.sv(
            customNavigationBar
        )
        showView()
    }
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .singleLine
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.height(screenH - (screenH / 12)).width(screenW)
//        tableView.top(screenH / 12)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        tableView.backgroundColor = UIColor(rgb: 0xECAFCC)

        
        self.tableView = tableView
    }
    
    private func registerTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(MeteoDataCell.self, forCellReuseIdentifier: "MeteoDataCell")
        let headerView = StretchyTableHeaderView(frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 120))
        headerView.imageView.image = UIImage(named: "headerbg")
        self.tableView.tableHeaderView = headerView
    }
    
    func showView() {
        backView.tintColor = .black
        view.addSubview(backView)
        
        backView.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension MeteoDataController: UITableViewDelegate {
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

extension MeteoDataController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MeteoDataCell", for: indexPath) as? MeteoDataCell
        cell?.selectionStyle = .none
//        cell?.imageUI?.image = UIImage(named: "imageMeteo\(indexPath.row - 1)")
        cell?.labelTwo?.text = "\(arrayMeteo[indexPath.row])"
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        if indexPath.row == 0 {
            cell?.layer.cornerRadius = 40
            cell?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        } else {
            cell?.layer.cornerRadius = 0
        }
        cell = accessoryType(cell: tableViewCell)
        tableViewCell.viewModel = cellViewModel

        return tableViewCell
    }
    
    func accessoryType(cell: MeteoDataCell) -> MeteoDataCell {
        cell.accessoryType = .disclosureIndicator
        cell.tintColor = .gray
        let image = UIImage(named:"Arrow")?.withRenderingMode(.alwaysTemplate)
        if let width = image?.size.width, let height = image?.size.height {
            let disclosureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            disclosureImageView.image = image
            cell.accessoryView = disclosureImageView
        }
        return cell
    }
    func accessoryTypeNone(cell: MeteoDataCell) -> MeteoDataCell {
        cell.accessoryType = .none
        cell.accessoryView = .none
        return cell
    }
}

extension MeteoDataController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! StretchyTableHeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView)
        
        var offset = scrollView.contentOffset.y / 150
        print(offset)
        if offset > 1 {
            offset = 1
            customNavigationBar.alpha = offset
        } else {
            customNavigationBar.alpha = offset
        }
    }
}
