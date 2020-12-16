//
//  OnlineDataDeviceCell.swift
//  SOKOL
//
//  Created by Володя Зверев on 19.11.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import YandexMapsMobile

class OnlineDataDeviceCell: UICollectionViewCell {
    
    var tableView: UITableView!
//    var label: UILabel!
    weak var content: UIView!
//    weak var imageUI: UIImageView!
//    weak var imageHumanUI: UIImageView!
//    weak var textView: UIView!
    var emptyList: UILabel!
    weak var delegate: DeviceDelegate?
    
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
        requestParametrs()
        self.initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func requestParametrs() {
        guard let select = selectItem,
              let id = devicesList[select].id else {return}
        networkingPostRequestListDevice(urlString: "http://185.27.193.112:8004/device/parameter/\(id)")
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
        tableView.register(OnlineDataCell.self, forCellReuseIdentifier: "OnlineDataCell")
        tableView.register(OnlineDataMapCell.self, forCellReuseIdentifier: "OnlineDataMapCell")
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
            self.tableView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -50),
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

extension OnlineDataDeviceCell: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OnlineDataMapCell", for: indexPath) as! OnlineDataMapCell
            if devicesParametrsList.count != 0 {
                guard let select = selectItem,
                      let latitude : Double = Double(devicesList[select].latitude!),
                      let longitude : Double = Double(devicesList[select].longitude!)
                else { return OnlineDataMapCell() }
                self.hero.isEnabled = true
                cell.mapView.hero.id = "YandexMap"
                cell.mapView.addTapGesture {
                    self.delegate?.buttonTap()
                }
            let mapObjects = cell.mapView.mapWindow.map.mapObjects
                let placemark = mapObjects.addPlacemark(with: YMKPoint(latitude: latitude, longitude: longitude))
                placemark.opacity = 1.0
                placemark.isDraggable = false
                placemark.setIconWith(UIImage(named:"StickerMap")!)
            }

            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OnlineDataCell", for: indexPath) as! OnlineDataCell
            cell.label.text = devicesParametrsList[indexPath.row - 1].name
            guard let value = devicesParametrsList[indexPath.row - 1].calculationOrder else { return cell }
            cell.labelValue.text = "\(value)"
            return cell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if devicesParametrsList.count == 0 {
            emptyList.isHidden = false
        } else {
            emptyList.isHidden = true
        }
        return devicesParametrsList.count + 1
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

    }
}
