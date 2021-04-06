//
//  UIViewController.swift
//  Toner
//
//  Created by Users on 09/11/19.
//  Copyright © 2019 Users. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIViewController
{
    
    func setNavigationBar(title: String, isBackButtonRequired:Bool = false, isTransparent: Bool = true){
        
        self.title = title
        if isTransparent{
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }
        self.navigationController?.navigationBar.isTranslucent = isTransparent
        self.navigationController?.navigationBar.barStyle = .black
        if isTransparent{
            self.navigationController?.navigationBar.barTintColor = .white
        }else{
            self.navigationController?.navigationBar.barTintColor = ThemeColor.backgroundColor
        }
        
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.montserratMedium.withSize(16)]
        if isBackButtonRequired{
            let backButton = UIButton(type: .custom)
            backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            backButton.addTarget(self, action: #selector(self.backButtonAction), for: .touchUpInside)
            backButton.setImage(UIImage(named: "back"), for: .normal)
            backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
            let leftBarButton = UIBarButtonItem(customView: backButton)
            self.navigationItem.leftBarButtonItem = leftBarButton

        }
    }
    
    @objc func backButtonAction(){
        
        self.navigationController?.dismiss(animated: true, completion: {
            return
        })
        self.navigationController?.popViewController(animated: true)
    }
    
    func addActivityIndicator(type: NVActivityIndicatorType = .ballSpinFadeLoader) -> NVActivityIndicatorView{
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: type, color: ThemeColor.buttonColor, padding: .zero)
        activityIndicator.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        return activityIndicator
    }
    

    func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Alert!",
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )

        alert.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        ))

        self.present(
            alert,
            animated: true,
            completion: nil
        )
    }
    
    var topView: UIView{
        self.appD.topViewController()?.view ?? UIView()
    }
    
}

extension NSObject{
    var appD : AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
}

