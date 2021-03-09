//
//  File.swift
//  SOKOL
//
//  Created by Володя Зверев on 24.12.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit
import YandexMapsMobile

class ForecastDataDeviceCell: UICollectionViewCell {
    
    var tableView: UITableView!
    let networkManager = NetworkManager()
    weak var content: UIView!
    var emptyList: UILabel!
    weak var delegate: DeviceDelegate?
    var forecastModel: ForcastModel = ForcastModel()
    let viewModel: ServiceModel = ServiceModel()
    var tagSelectedIndex = 2

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
        viewAlphaAlways.isHidden = false
        let days = viewModel.daysForecast()
        guard let firstDay = days.first,
              let lastDay = days.last else {return}
        networkManager.networkingPostRequestForecast(selectId: id, startDateString: "\(firstDay)", endDateString: "\(lastDay)") { (result, error) in
            guard let result = result else {return}
            forecast = result
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
        tableView.backgroundColor = .white
        self.contentView.addSubview(tableView)
        self.tableView = tableView
    }
    func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OnlineDataCell.self, forCellReuseIdentifier: "OnlineDataCell")
        tableView.register(SegmentedDateCell.self, forCellReuseIdentifier: "SegmentedDateCell")
        tableView.register(OnlineDeviceCell.self, forCellReuseIdentifier: "OnlineDeviceCell")

    }
    
    func initialize() {
        let content = UIView()
        content.backgroundColor = .clear
        content.translatesAutoresizingMaskIntoConstraints = false

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
        
        NSLayoutConstraint.activate([
            self.content!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            self.content!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            self.content!.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.content!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            self.tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: screenH / 12 ),
            self.tableView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            self.tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            self.emptyList.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            self.emptyList.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            self.emptyList.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 30),
            self.emptyList.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -30)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

extension ForecastDataDeviceCell: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentedDateCell", for: indexPath) as! SegmentedDateCell
            guard let select = selectItem else { return OnlineDeviceCell() }
            cell.delegate = self
//            cell.label.text = devicesList[select].name
//            cell.imageUI.image = UIImage(named: "EllipseSokolName")
//            cell.labelValue.text = "Обновлено 5 сек. назад"
            return cell
        } else if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OnlineDeviceCell", for: indexPath) as! OnlineDeviceCell
            guard let select = selectItem else { return OnlineDeviceCell() }
            cell.label.text = devicesList[select].name
            cell.imageUI.image = UIImage(named: "EllipseSokolName")
            cell.labelValue.text = "Обновлено 5 сек. назад"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OnlineDataCell", for: indexPath) as! OnlineDataCell
            if forecast.count == 3 {
                if let tmin = forecast[tagSelectedIndex].tMin {
                    self.forecastModel.forecastName[0].value = "\(tmin)"
                } else {
                    self.forecastModel.forecastName[0].value = "..."
                }
                if let tmax = forecast[tagSelectedIndex].tMax {
                    self.forecastModel.forecastName[1].value = "\(tmax)"
                } else {
                    self.forecastModel.forecastName[2].value = "..."
                }
                if let rNight = forecast[tagSelectedIndex].rNight {
                    self.forecastModel.forecastName[2].value = "\(rNight)"
                } else {
                    self.forecastModel.forecastName[2].value = "..."
                }
                if let rDay = forecast[tagSelectedIndex].rDay {            self.forecastModel.forecastName[3].value = "\(rDay)"
                } else {
                    self.forecastModel.forecastName[3].value = "..."
                }
                if let wsNight = forecast[tagSelectedIndex].wsNight {            self.forecastModel.forecastName[4].value = "\(wsNight)"
                } else {
                    self.forecastModel.forecastName[4].value = "..."
                }
                if let wsDay = forecast[tagSelectedIndex].wsDay {            self.forecastModel.forecastName[5].value = "\(wsDay)"
                } else {
                    self.forecastModel.forecastName[5].value = "..."
                }
                if let wdNight = forecast[tagSelectedIndex].wdNight {
                    self.forecastModel.forecastName[6].value = "\(wdNight)"
                } else {
                    self.forecastModel.forecastName[6].value = "..."
                }
                if let wdDay = forecast[tagSelectedIndex].wdDay {
                    self.forecastModel.forecastName[7].value = "\(wdDay)"
                } else {
                    self.forecastModel.forecastName[7].value = "..."
                }
                if let hmNight = forecast[tagSelectedIndex].hmNight {
                    self.forecastModel.forecastName[8].value = "\(hmNight)"
                } else {
                    self.forecastModel.forecastName[8].value = "..."
                }
                if let hmDay = forecast[tagSelectedIndex].hmDay {
                    self.forecastModel.forecastName[9].value = "\(hmDay)"
                } else {
                    self.forecastModel.forecastName[9].value = "..."
                }
                if let p0Night = forecast[tagSelectedIndex].p0Night {
                    self.forecastModel.forecastName[10].value = "\(p0Night)"
                } else {
                    self.forecastModel.forecastName[10].value = "..."
                }
                if let p0Day = forecast[tagSelectedIndex].p0Day {
                    self.forecastModel.forecastName[11].value = "\(p0Day)"
                } else {
                    self.forecastModel.forecastName[11].value = "..."
                }
            } else if forecast.count == 1 {
                if let tmin = forecast[0].tMin {
                    self.forecastModel.forecastName[0].value = "\(tmin)"
                } else {
                    self.forecastModel.forecastName[0].value = "..."
                }
                if let tmax = forecast[0].tMax {
                    self.forecastModel.forecastName[1].value = "\(tmax)"
                } else {
                    self.forecastModel.forecastName[2].value = "..."
                }
                if let rNight = forecast[0].rNight {
                    self.forecastModel.forecastName[2].value = "\(rNight)"
                } else {
                    self.forecastModel.forecastName[2].value = "..."
                }
                if let rDay = forecast[0].rDay {            self.forecastModel.forecastName[3].value = "\(rDay)"
                } else {
                    self.forecastModel.forecastName[3].value = "..."
                }
                if let wsNight = forecast[0].wsNight {            self.forecastModel.forecastName[4].value = "\(wsNight)"
                } else {
                    self.forecastModel.forecastName[4].value = "..."
                }
                if let wsDay = forecast[0].wsDay {            self.forecastModel.forecastName[5].value = "\(wsDay)"
                } else {
                    self.forecastModel.forecastName[5].value = "..."
                }
                if let wdNight = forecast[0].wdNight {
                    self.forecastModel.forecastName[6].value = "\(wdNight)"
                } else {
                    self.forecastModel.forecastName[6].value = "..."
                }
                if let wdDay = forecast[0].wdDay {
                    self.forecastModel.forecastName[7].value = "\(wdDay)"
                } else {
                    self.forecastModel.forecastName[7].value = "..."
                }
                if let hmNight = forecast[0].hmNight {
                    self.forecastModel.forecastName[8].value = "\(hmNight)"
                } else {
                    self.forecastModel.forecastName[8].value = "..."
                }
                if let hmDay = forecast[0].hmDay {
                    self.forecastModel.forecastName[9].value = "\(hmDay)"
                } else {
                    self.forecastModel.forecastName[9].value = "..."
                }
                if let p0Night = forecast[0].p0Night {
                    self.forecastModel.forecastName[10].value = "\(p0Night)"
                } else {
                    self.forecastModel.forecastName[10].value = "..."
                }
                if let p0Day = forecast[0].p0Day {
                    self.forecastModel.forecastName[11].value = "\(p0Day)"
                } else {
                    self.forecastModel.forecastName[11].value = "..."
                }
            } else if forecast.count == 2 {
                tagSelectedIndex -= 1
                if let tmin = forecast[tagSelectedIndex].tMin {
                    self.forecastModel.forecastName[0].value = "\(tmin)"
                } else {
                    self.forecastModel.forecastName[0].value = "..."
                }
                if let tmax = forecast[tagSelectedIndex].tMax {
                    self.forecastModel.forecastName[1].value = "\(tmax)"
                } else {
                    self.forecastModel.forecastName[2].value = "..."
                }
                if let rNight = forecast[tagSelectedIndex].rNight {
                    self.forecastModel.forecastName[2].value = "\(rNight)"
                } else {
                    self.forecastModel.forecastName[2].value = "..."
                }
                if let rDay = forecast[tagSelectedIndex].rDay {            self.forecastModel.forecastName[3].value = "\(rDay)"
                } else {
                    self.forecastModel.forecastName[3].value = "..."
                }
                if let wsNight = forecast[tagSelectedIndex].wsNight {            self.forecastModel.forecastName[4].value = "\(wsNight)"
                } else {
                    self.forecastModel.forecastName[4].value = "..."
                }
                if let wsDay = forecast[tagSelectedIndex].wsDay {            self.forecastModel.forecastName[5].value = "\(wsDay)"
                } else {
                    self.forecastModel.forecastName[5].value = "..."
                }
                if let wdNight = forecast[tagSelectedIndex].wdNight {
                    self.forecastModel.forecastName[6].value = "\(wdNight)"
                } else {
                    self.forecastModel.forecastName[6].value = "..."
                }
                if let wdDay = forecast[tagSelectedIndex].wdDay {
                    self.forecastModel.forecastName[7].value = "\(wdDay)"
                } else {
                    self.forecastModel.forecastName[7].value = "..."
                }
                if let hmNight = forecast[tagSelectedIndex].hmNight {
                    self.forecastModel.forecastName[8].value = "\(hmNight)"
                } else {
                    self.forecastModel.forecastName[8].value = "..."
                }
                if let hmDay = forecast[tagSelectedIndex].hmDay {
                    self.forecastModel.forecastName[9].value = "\(hmDay)"
                } else {
                    self.forecastModel.forecastName[9].value = "..."
                }
                if let p0Night = forecast[tagSelectedIndex].p0Night {
                    self.forecastModel.forecastName[10].value = "\(p0Night)"
                } else {
                    self.forecastModel.forecastName[10].value = "..."
                }
                if let p0Day = forecast[tagSelectedIndex].p0Day {
                    self.forecastModel.forecastName[11].value = "\(p0Day)"
                } else {
                    self.forecastModel.forecastName[11].value = "..."
                }
            }
            if forecastModel.forecastName[indexPath.row - 2].value == "..." {
                cell.imageUI.isHidden = true
                cell.labelValue.isHidden = true
                cell.nextImage.isHidden = true
                return cell
            } else {
                cell.imageUI.isHidden = false
                cell.labelValue.isHidden = false
                cell.nextImage.isHidden = false
                cell.labelValue.text = forecastModel.forecastName[indexPath.row - 2].value
                cell.label.text = forecastModel.forecastName[indexPath.row - 2].name
                cell.imageUI.image = UIImage(named: "\(forecastModel.forecastName[indexPath.row - 2].image)")
                return cell
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if forecast.count == 0 {
            emptyList.isHidden = false
        } else {
            emptyList.isHidden = true
            return forecastModel.forecastName.count + 2
        }
        return 0
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
        if indexPath.row == 1 || indexPath.row == 0 {
            return UITableView.automaticDimension
        } else if forecastModel.forecastName[indexPath.row - 2].value == "..." {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension ForecastDataDeviceCell: ForecastDelegate {
    
    func senderSelectedIndex(tag: Int) {
        tagSelectedIndex = tag
        tableView.reloadData()
    }
}
