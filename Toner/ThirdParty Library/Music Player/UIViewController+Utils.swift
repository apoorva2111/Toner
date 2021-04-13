//
//  UIViewController+Utils.swift
//  SpotifyPlayer
//
//  Created by Maksym Shcheglov on 17/05/2020.
//  Copyright © 2020 Maksym Shcheglov. All rights reserved.
//

import UIKit

extension UIViewController {
    public func add(_ child: UIViewController, insets: UIEdgeInsets = .zero) {
        addChild(child)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        let getiPhone = getPhoneScreen()
        if getiPhone == .iphone6 || getiPhone == .iphonePlus {
            NSLayoutConstraint.activate([
                child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                child.view.topAnchor.constraint(equalTo: view.topAnchor),
                //                child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50)
            ])
            
        }else{
            NSLayoutConstraint.activate([
                child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                child.view.topAnchor.constraint(equalTo: view.topAnchor),
                //                child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80)
            ])
        }
        child.didMove(toParent: self)
    }
    
    public func remove(_ child: UIViewController) {
        guard child.parent != nil else {
            return
        }
        
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}

enum IphoneScreen{
    case iphone5 //"iPhone 5 or 5S or 5C"
    case iphone6 //"iPhone 6/6S/7/8"
    case iphonePlus //"iPhone 6+/6S+/7+/8+"
    case iphoneX //"iPhone X"
    case iphoneXSMax //"iPhone XSMax"
    case unknown
}


func getPhoneScreen()->IphoneScreen{
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {

        case 1136:
            return IphoneScreen.iphone5
        case 1334:
            return IphoneScreen.iphone6
        case 2208:
            return IphoneScreen.iphonePlus
        case 2436:
            return IphoneScreen.iphoneX
        case 2688:
            return IphoneScreen.iphoneXSMax
        default:
            return IphoneScreen.unknown
        }
    }
    return IphoneScreen.unknown
}
