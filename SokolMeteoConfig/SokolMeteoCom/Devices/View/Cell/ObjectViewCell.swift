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
        networkingPostRequestListDevice(urlString: "http://185.27.193.112:8004/device/all?start=0&count=10&sortDir=asc")
        
        self.initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.height(screenH - (screenH / 12)).width(screenW)
//        tableView.top(screenH / 12)
        tableView.backgroundColor = .white
        self.contentView.addSubview(tableView)
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

        //        emptyList.isHidden = false

//        let imageUI = UIImageView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenW * 1.78))
//        imageUI.image = UIImage(named: "swipe 0")
//        imageUI.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
//        imageUI.layer.shadowRadius = 6.0
//        imageUI.layer.shadowOpacity = 0.5
//        imageUI.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        imageUI.translatesAutoresizingMaskIntoConstraints = false
//        self.content.addSubview(imageUI)
//        self.imageUI = imageUI
        
//        let textView = UIView()
//        textView.backgroundColor = .white
//        textView.layer.cornerRadius = 20
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
//        textView.layer.shadowRadius = 6.0
//        textView.layer.shadowOpacity = 0.5
//        textView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        self.content.addSubview(textView)
//        self.textView = textView
        
//        let label = UILabel()
//        label.font = UIFont(name:"FuturaPT-Medium", size: screenW / 18)
//        label.textAlignment = .center
//        label.textColor = UIColor(rgb: 0x321550)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.numberOfLines = 0
//        self.textView.addSubview(label)
//        self.label = label
        
//        let imageHumanUI = UIImageView()
//        imageHumanUI.image = UIImage(named: "human 0")
////        imageUI.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
////        imageUI.layer.shadowRadius = 6.0
////        imageUI.layer.shadowOpacity = 0.5
////        imageUI.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        imageHumanUI.translatesAutoresizingMaskIntoConstraints = false
//        self.content.addSubview(imageHumanUI)
//        self.imageHumanUI = imageHumanUI
        
        NSLayoutConstraint.activate([
            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.content!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

//            self.label!.centerXAnchor.constraint(equalTo: self.textView!.centerXAnchor),
//            self.label!.centerYAnchor.constraint(equalTo: self.textView!.centerYAnchor),
//            self.label!.leadingAnchor.constraint(equalTo: self.textView!.leadingAnchor,constant: 30),
//            self.label!.trailingAnchor.constraint(equalTo: self.textView!.trailingAnchor,constant: -30),

            self.tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: screenH / 12 ),
            self.tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            self.emptyList.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            self.emptyList.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            self.emptyList.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 30),
            self.emptyList.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -30)

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

extension ObjectViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! DeviceCell
        cell.label.text = devicesList[indexPath.row].name
        
        return cell
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
        delegate?.buttonTap()
    }
}
