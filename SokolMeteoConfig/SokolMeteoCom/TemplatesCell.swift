//
//  TemplatesCell.swift
//  SOKOL
//
//  Created by Володя Зверев on 01.02.2021.
//  Copyright © 2021 zverev. All rights reserved.
//

import UIKit

class TemplatesCell: UITableViewCell {
    var nowTo = Date()
    var nowFrom = Date()

    var viewBackground: UIView!
    var labelName: UILabel!
    
    var pickerViewTo: UIDatePicker!
    var pickerViewFrom: UIDatePicker!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        
        contentView.backgroundColor = .white
        let content = UIView()
        content.backgroundColor = .white
        content.translatesAutoresizingMaskIntoConstraints = false
        content.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        content.layer.shadowRadius = 3.0
        content.layer.shadowOpacity = 0.1
        content.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        content.layer.cornerRadius = 30
        self.contentView.addSubview(content)
        self.viewBackground = content

        let label = UILabel()
        label.font = UIFont(name:"FuturaPT-Light", size: screenW / 20)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        self.viewBackground.addSubview(label)
        self.labelName = label
                
        let pickerViewTo = UIDatePicker()
        pickerViewTo.layer.cornerRadius = 10
        pickerViewTo.datePickerMode = .date
        pickerViewTo.translatesAutoresizingMaskIntoConstraints = false
        let now = Date()
        let year = Calendar.current.date(byAdding: .year, value: -1, to: now)
        pickerViewTo.maximumDate = now
        pickerViewTo.minimumDate = year
        pickerViewTo.addTarget(self, action: #selector(datePickerChangedTo(picker:)), for: .valueChanged)
        self.viewBackground.addSubview(pickerViewTo)
        self.pickerViewTo = pickerViewTo
        
        let pickerViewFrom = UIDatePicker()
        pickerViewFrom.layer.cornerRadius = 10
        pickerViewFrom.datePickerMode = .date
        pickerViewFrom.translatesAutoresizingMaskIntoConstraints = false
        pickerViewFrom.maximumDate = now
        pickerViewFrom.minimumDate = now
        pickerViewFrom.addTarget(self, action: #selector(datePickerChangedFrom(picker:)), for: .valueChanged)
        self.viewBackground.addSubview(pickerViewFrom)
        self.pickerViewFrom = pickerViewFrom
                
        NSLayoutConstraint.activate([
            self.viewBackground!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.viewBackground!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            self.viewBackground!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.viewBackground!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            self.viewBackground!.bottomAnchor.constraint(equalTo: self.pickerViewFrom.bottomAnchor, constant: 35),
//
            self.labelName!.topAnchor.constraint(equalTo: self.viewBackground!.topAnchor, constant: 15),
            self.labelName!.leadingAnchor.constraint(equalTo: self.viewBackground!.leadingAnchor, constant: 20),
            self.labelName!.trailingAnchor.constraint(equalTo: self.viewBackground!.trailingAnchor, constant: -20),

            self.pickerViewTo.topAnchor.constraint(equalTo: self.labelName!.bottomAnchor, constant: 10),
            self.pickerViewTo.centerXAnchor.constraint(equalTo: self.viewBackground!.centerXAnchor),
//            self.pickerView.trailingAnchor.constraint(equalTo: self.viewBackground!.trailingAnchor, constant: -40),

            self.pickerViewFrom.topAnchor.constraint(equalTo: self.pickerViewTo.bottomAnchor, constant: 10),
            self.pickerViewFrom.centerXAnchor.constraint(equalTo: self.viewBackground!.centerXAnchor),
        ])
    }
    
    @objc func datePickerChangedTo(picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = .current
        nowTo = picker.date
        let txtDatePicker = formatter.string(from: picker.date)
        let now = nowFrom
        pickerViewTo.maximumDate = now
        pickerViewFrom.minimumDate = nowTo
        orderDateTo = txtDatePicker
        print(txtDatePicker)
    }
    @objc func datePickerChangedFrom(picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = .current
        nowFrom = picker.date
        let now = nowTo
        pickerViewTo.maximumDate = nowFrom
        pickerViewFrom.minimumDate = now
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: picker.date)
        let txtDatePicker = formatter.string(from: tomorrow!)
        orderDateFrom = txtDatePicker
        print(txtDatePicker)
    }
    
    @objc func update() {
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
