//
//  ObjectViewCell.swift
//  SOKOL
//
//  Created by Володя Зверев on 17.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

class ObjectViewCell: UICollectionViewCell {
    
    var tableView: UITableView!
//    var label: UILabel!
    weak var content: UIView!
//    weak var imageUI: UIImageView!
//    weak var imageHumanUI: UIImageView!
//    weak var textView: UIView!
    var emptyList: UILabel!
    weak var delegate: DevicesDelegate?
    let networkManager = NetworkManager()
    var addDeviceVC = AddDeviceViewController()
    
    let generator = UIImpactFeedbackGenerator(style: .light)

    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
//        let title = NSLocalizedString("PullToRefresh", comment: "Отпустите")
        refreshControl.tintColor = .purple
//        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self,
                                 action: #selector(refreshOptions(sender:)),
                                 for: .valueChanged)
        return refreshControl
    }()
    
    var buttonPlus: UIButton!
    
    @objc func actionAddPush() {
        delegate?.actionPushAdd(edit: false)
    }
    
    @objc func refreshOptions(sender: UIRefreshControl) {
        print("LOLOLOLO")
        networkManager.networkingPostRequestListDevice { (data, error) in
            DispatchQueue.main.async {
                sender.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override var bounds: CGRect {
            didSet {
                self.layoutIfNeeded()
            }
        }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
//        requestParametrs()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func requestParametrs() {
        viewAlphaAlways.isHidden = false
        networkManager.networkingPostRequestListDevice { (data, error) in
            DispatchQueue.main.async {
                viewAlphaAlways.isHidden = true
                self.tableView.reloadData()
            }
        }
    }
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.height(screenH - (screenH / 12)).width(screenW)
//        tableView.top(screenH / 12)
        tableView.backgroundColor = .white
        tableView.refreshControl = refreshControl
        self.content.addSubview(tableView)
        self.tableView = tableView
    }
    func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeviceCell.self, forCellReuseIdentifier: "DeviceCell")
    }
    
    func initialize() {
        let content = UIView()
        content.backgroundColor = .clear
        content.translatesAutoresizingMaskIntoConstraints = false
//        content.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
//        content.layer.shadowRadius = 3.0
//        content.layer.shadowOpacity = 0.1
//        content.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        content.layer.cornerRadius = 10
//        let touchDown = UITapGestureRecognizer(target:self, action: #selector(didTouchDown))
//        content.addGestureRecognizer(touchDown)

        self.contentView.addSubview(content)
        self.content = content
        createTableView()
        registerCell()
        let emptyList = UILabel()
        emptyList.text = "СПИСОК ПУСТ"
        emptyList.numberOfLines = 0
        emptyList.textAlignment = .center
        emptyList.font = UIFont(name: "FuturaPT-Light", size: screenW / 16)
        emptyList.textColor = .gray
        emptyList.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.addSubview(emptyList)
        self.emptyList = emptyList
        
        let buttonPlus = UIButton()
        buttonPlus.setImage(UIImage(named: "pluisView"), for: .normal)
        buttonPlus.showsTouchWhenHighlighted = true
        buttonPlus.setTitleColor(UIColor(rgb: 0xB64894), for: .highlighted)
        buttonPlus.translatesAutoresizingMaskIntoConstraints = false
        buttonPlus.addTarget(self, action: #selector(actionAddPush), for: .touchUpInside)
        self.content.addSubview(buttonPlus)
        self.buttonPlus = buttonPlus

        NSLayoutConstraint.activate([
            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
            self.content!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            self.tableView.topAnchor.constraint(equalTo: self.content.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.content.bottomAnchor, constant: -100),
            self.tableView.leadingAnchor.constraint(equalTo: self.content.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.content.trailingAnchor),

            self.emptyList.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            self.emptyList.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            self.emptyList.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 30),
            self.emptyList.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -30),
            
            self.buttonPlus.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -110),
            self.buttonPlus.trailingAnchor.constraint(equalTo: self.content.trailingAnchor, constant: -20)

//            self.textView!.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: screenH / 12),
//            self.textView!.leadingAnchor.constraint(equalTo: self.content!.leadingAnchor, constant: 20),
//            self.textView!.trailingAnchor.constraint(equalTo: self.content!.trailingAnchor, constant: -20),
//            self.textView.heightAnchor.constraint(equalToConstant: screenH / 9)
//            self.imageUI!.heightAnchor.constraint(equalToConstant: 40),
//            self.imageUI!.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension ObjectViewCell: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! DeviceCell
        cell.label.text = devicesList[indexPath.row].name
        cell.backgroundColor = .blue

//        cell.nextImage.addTarget(self, action: #selector(optionSettingsAcction), for: .touchUpInside)
        cell.nextImage.addTapGesture {
            self.generator.impactOccurred()
            self.delegate?.alertSetupVisualEffectView(name: devicesList[indexPath.row].name!, tag: indexPath.row)
        }
        return cell
    }
    @objc func optionSettingsAcction() {
        generator.impactOccurred()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if devicesList.count == 0 {
            emptyList.isHidden = false
        } else {
            emptyList.isHidden = true
        }
        return devicesList.count
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 0 {
            self.buttonPlus.transform = CGAffineTransform(translationX: 0, y: scrollView.contentOffset.y)
        } else {
            self.buttonPlus.transform = CGAffineTransform(translationX: 0, y: 0)
        }

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
        selectItem = indexPath.row
        delegate?.buttonTap(tag: indexPath.row)
    }
}
