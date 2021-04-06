//
//  UIView.swift
//  MANCHESTER MASSAGE
//
//  Created by Users on 19/01/20.
//  Copyright © 2020 Users. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func makeShadow(){
        let yourView = self
        yourView.layer.shadowColor = UIColor.black.cgColor
        yourView.layer.shadowOpacity = 0.5
        yourView.layer.shadowOffset = .zero
        yourView.layer.shadowRadius = 20
        yourView.layer.shadowPath = UIBezierPath(rect: yourView.frame).cgPath
        yourView.layer.shouldRasterize = true
        yourView.layer.rasterizationScale = UIScreen.main.scale
    }
}


@IBDesignable class CardView: UIView {
    var cornnerRadius : CGFloat = 8
    var shadowOfSetWidth : CGFloat = 0
    var shadowOfSetHeight : CGFloat = 5
    
    var shadowColour : UIColor = UIColor.darkGray
    var shadowOpacity : CGFloat = 0.2
    
    override func layoutSubviews() {
        layer.cornerRadius = cornnerRadius
        layer.shadowColor = shadowColour.cgColor
        layer.shadowOffset = CGSize(width: shadowOfSetWidth, height: shadowOfSetHeight)
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornnerRadius)
        
        layer.shadowPath = shadowPath.cgPath
        
        layer.shadowOpacity = Float(shadowOpacity)
        
    }

}
