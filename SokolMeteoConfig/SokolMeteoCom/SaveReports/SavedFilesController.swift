//
//  SavedFilesController.swift
//  SOKOL
//
//  Created by Володя Зверев on 20.04.2021.
//  Copyright © 2021 zverev. All rights reserved.
//


import UIKit

class SavedFilesController: UIViewController {
    
    var tableView: UITableView!
    let generator = UIImpactFeedbackGenerator(style: .light)
    var isBackBox = false
    
    lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: screenH / 12 - 50, width: 50, height: 50)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.frame = CGRect(x: 10, y: 0 , width: 20, height: 20)
        back.center.y = backView.bounds.height / 3 * 2 - 1
        backView.addSubview(back)
        return backView
    }()
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        self.view.sv(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenH / 12).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        tableView.backgroundColor = .white
        self.tableView = tableView
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        WorkWithFiles.sortedFilesForFolder(isBackBox: isBackBox) {
            WorkWithFiles.countFile(isBlackBox: self.isBackBox, completion: {
                self.tableView.reloadData()
            })
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let customNavigationBar = createCustomNavigationBar(title: isBackBox ? "СПИСОК ЧЕРНОГО ЯЩИКА": "СПИСОК ОТЧЕТОВ",fontSize: screenW / 22)
        self.hero.isEnabled = true
        createTableView()
        registerCell()
        view.sv(customNavigationBar, backView)
        customNavigationBar.hero.id = "SOKOLMETEO"
        backView.addTapGesture { [self] in self.popVC() }
        
    }
    
    func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SavedReportsCell.self, forCellReuseIdentifier: "SavedReportsCell")

    }
    func popVC() {
        dismiss(animated: true)
    }
}
extension SavedFilesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedReportsCell", for: indexPath) as! SavedReportsCell
        cell.label.text = WorkWithFiles.urlFiles?[indexPath.row].lastPathComponent
        cell.labelMac.text = WorkWithFiles.dateFile(index: indexPath.row)
        guard let count = WorkWithFiles.countFiles?[indexPath.row] else { return cell }
        cell.labelSize.text = "\(count)" + " шт"
        cell.imageUI.image = UIImage(named: "directory_Image")
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkWithFiles.urlFiles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        generator.impactOccurred()
//        UIView.animate(withDuration: 0.5) {
//            let cell  = tableView.cellForRow(at: indexPath) as? BlackBoxListCell
//            cell!.nextImage!.tintColor = UIColor(rgb: 0xBE449E)
//            cell!.label!.textColor = UIColor(rgb: 0xBE449E)
//            cell?.contentView.backgroundColor = UIColor(rgb: 0xECECEC)
//        }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.2) {
//            let cell  = tableView.cellForRow(at: indexPath) as? BlackBoxListCell
//            cell!.nextImage!.tintColor = UIColor(rgb: 0x998F99)
//            cell?.selectionStyle = .none
//            cell!.label!.textColor = .black
//            cell?.contentView.backgroundColor = .white
//        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SavedReportsController()
        let name = WorkWithFiles.nameFile(index: indexPath.row)
        vc.name = name!
        vc.isBackBox = isBackBox
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
