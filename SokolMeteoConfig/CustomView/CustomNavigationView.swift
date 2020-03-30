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
        
    var bgColor: UIColor = .gray
    
    var textColor: UIColor = .white

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
        addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTap(recognizer:)))
        )
        
    }
    
    // MARK: - Actions
    
    @objc
    private func didTap(recognizer: UITapGestureRecognizer) {
        print("123")
    }
    
    // MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setFillColor(bgColor.cgColor)
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
        rect.origin.y = (frame.height - size.height) / 3 * 2
        rect.size.height = size.height
        string.draw(in: rect)
    }
    
}
