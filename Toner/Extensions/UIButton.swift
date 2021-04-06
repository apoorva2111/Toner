//
//  UIButton.swift
//  MANCHESTER MASSAGE
//
//  Created by Users on 15/01/20.
//  Copyright © 2020 Users. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    func setLeftImage(image: FAType, color: UIColor = .white, state: UIControl.State = .normal){
        let origImage = UIImage(icon: image, size: CGSize(width: 30, height: 30))
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: state)
        self.tintColor = color
    }
    
    func setSupportButton(image: FAType, title: String){
        self.setLeftImage(image: image, color: .darkGray, state: .normal)
        self.setTitleColor(.darkGray, for: .normal)
        self.setTitle(title, for: .normal)
        self.contentHorizontalAlignment = .left
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    func setSupportFooterButton(title: String){
        self.setTitleColor(.darkGray, for: .normal)
        self.setTitle(title, for: .normal)
        self.contentHorizontalAlignment = .left
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    func dropShadow(cornnerRadius: CGFloat = 8.0, shadowColour: UIColor = .darkGray, shadowOfSetWidth: CGFloat = 0, shadowOfSetHeight: CGFloat = 5.0, shadowOpacity: CGFloat = 0.2) {
        layer.cornerRadius = cornnerRadius
        layer.shadowColor = shadowColour.cgColor
        layer.shadowOffset = CGSize(width: shadowOfSetWidth, height: shadowOfSetHeight)
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornnerRadius)
        
        layer.shadowPath = shadowPath.cgPath
        
        layer.shadowOpacity = Float(shadowOpacity)
        backgroundColor = .white
        
    }
}
