//
//  ChangePasswordViewController.swift
//  Toner
//
//  Created by User on 26/09/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    
    var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = ThemeColor.backgroundColor
        self.setNavigationBar(title: "CHANGE PASSWORD", isBackButtonRequired: true, isTransparent: false)
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        self.updateButton.backgroundColor = ThemeColor.buttonColor
        self.updateButton.layer.cornerRadius = 10//self.updateButton.frame.height / 2
        self.updateButton.clipsToBounds = true
        self.updateButton.setTitleColor(.white, for: .normal)
        self.updateButton.setTitle("UPDATE", for: .normal)
        self.updateButton.addTarget(self, action: #selector(self.updateButtonAction), for: .touchUpInside)
        
        initialSetUp()
    }
    
    fileprivate func initialSetUp(){
        
        setUpTextFields(currentPassword, placeHolder: "Current Password")
        setUpTextFields(newPassword, placeHolder: "New Password")
        setUpTextFields(confirmPassword, placeHolder: "Confirm Password")
    }
    
    fileprivate func setUpTextFields(_ textField: UITextField, placeHolder: String){
        textField.text = ""
        textField.setPlaceholder(placeholder: placeHolder, color: .gray)
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.font = .montserratRegular
        textField.isSecureTextEntry = true
        textField.addButtomBorder(color: UIColor.darkGray.cgColor)
    }
    
    @objc func updateButtonAction(){
        
        if !(currentPassword.text?.isValidPassword ?? true){
            self.tabBarController?.view.makeToast(message: "Please enter current password")
            return
        }else if !(newPassword.text?.isValidPassword ?? true){
            self.tabBarController?.view.makeToast(message: "Please enter new password")
            return
        }else if !(confirmPassword.text?.isValidPassword ?? true){
            self.tabBarController?.view.makeToast(message: "Please enter confirm password")
            return
        }else if newPassword.text == currentPassword.text{
            self.tabBarController?.view.makeToast(message: "Current password is same as new password")
            return
        }
        else if confirmPassword.text != newPassword.text{
            self.tabBarController?.view.makeToast(message: "Passwords don't match")
            return
        }
        self.view.endEditing(true)
        let parameters = [
            "user_id": UserDefaults.standard.fetchData(forKey: .userId),
            "cpassword": currentPassword.text ?? "",
            "npassword": newPassword.text ?? "",
            "ccpassword": confirmPassword.text ?? ""
            ] as [String: String]
        
        self.activityIndicator.startAnimating()
        let reuestURL = "https://tonnerumusic.com/api/v1/changepassword"
        Alamofire.request(reuestURL, method: .post, parameters: parameters)
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                self.activityIndicator.stopAnimating()
                if (resposeJSON["status"] as? Int ?? 0) == 1{
                    self.showAlert(message: resposeJSON["message"] as? String ?? "Profile Password Updated Successfully.")
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.tabBarController?.view.makeToast(message: "Something went wrong. Please try again.")
                }
               
        }
   
    }
}
