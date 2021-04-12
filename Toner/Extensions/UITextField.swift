//
//  UITextField.swift
//  MANCHESTER MASSAGE
//
//  Created by Users on 15/01/20.
//  Copyright © 2020 Users. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{

    func addButtomBorder(color: CGColor = UIColor.gray.cgColor){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = color
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
        self.layer.masksToBounds = true
    }
    
    func setTextFieldImage(image: UIImage, direction: ImageDirection = .left){
        let imageView = UIImageView()
        let image = image
        imageView.image = image
        
        if direction == .left{
            self.leftView = imageView
        }
        else{
            self.rightView = imageView;
        }
    }
    
    func setTextFieldImage(image: FAType, direction: ImageDirection = .left){
        let imageView = UIImageView()
        let origImage = UIImage(icon: image, size: CGSize(width: 30, height: 30))
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        imageView.image = tintedImage
        imageView.tintColor = .gray
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if direction == .left{
            self.leftView = imageView
            self.leftViewMode = .always
            self.leftView = imageView
        }
        else{
            self.rightView = imageView
            self.rightViewMode = .always
            self.rightView = imageView
        }
    }
    func setIcon(_ image: UIImage) {
       let iconView = UIImageView(frame:
                      CGRect(x: 5, y: 5, width: 20, height: 20))
       iconView.image = image
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 10, y: 0, width: 30, height: 30))
        iconView.tintColor = .white
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }

    func setPlaceholder(placeholder: String, color: UIColor){
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
        attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

enum ImageDirection{
    case left, right
}

@IBDesignable class BottomBorderTextField: UITextField {
    
    @IBInspectable
    var bottomBorderColour : UIColor = UIColor.darkGray
    
    override func layoutSubviews() {
        self.addButtomBorder(color: bottomBorderColour.cgColor)
    }
}
