//
//  CustomNavigationView.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 30.03.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit

final class CustomNavigationView: UIView {
    // MARK: - Properties
    
    var title: String = "Контроллер"
        
    var bgColor: UIColor = .white
    
    var textColor: UIColor = .black

    var font: UIFont = .systemFont(ofSize: 22.0, weight: .bold)

    
    // MARK: - Private properties
    
    private lazy var paragraphStyle: NSParagraphStyle = {
        let paragraph = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraph.alignment = .center
        return paragraph.copy() as! NSParagraphStyle
    }()
    private var segmentSize: CGFloat {
        return frame.width
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    private func configure() {
//        addGestureRecognizer(
//            UITapGestureRecognizer(target: self, action: #selector(didTap(recognizer:)))
//        )
        
    }
    
    // MARK: - Actions
    
//    @objc
//    private func didTap(recognizer: UITapGestureRecognizer) {
//        print("123")
//    }
    
    // MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setFillColor(bgColor.cgColor)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor(rgb: 0xB64894).cgColor
        self.layer.shadowOffset = CGSize.zero
        
        let backgroundPath = UIBezierPath(rect: rect)
        backgroundPath.fill()
        
        let rect = CGRect(x: 0, y: 0, width: segmentSize, height: frame.height)
        
        draw(text: title, in: rect, color: textColor, font: font)
    }
    
    private func draw(text: String, in rect: CGRect, color: UIColor, font: UIFont) {

        var rect = rect
        let attributes: [NSAttributedString.Key: Any] = [.font: font,
                                                        .foregroundColor: color,
                                                        .paragraphStyle: paragraphStyle]
        let string = NSAttributedString(string: text, attributes: attributes)
        let size = string.size()
        rect.origin.y = screenH / 12 - (12 + screenW / 22)
        rect.size.height = size.height
        string.draw(in: rect)
    }
    
}
