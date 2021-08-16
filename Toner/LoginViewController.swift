//
//  LoginViewController.swift
//  Toner
//
//  Created by User on 15/07/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signinButton: UIButton!
    
    var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setNavigationBar(title: "", isBackButtonRequired: true)

        
        self.signinButton.addTarget(self, action: #selector(self.signinButtonAction), for: .touchUpInside)
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        self.signinButton.backgroundColor = ThemeColor.buttonColor
        self.signinButton.layer.cornerRadius = self.signinButton.frame.height / 2
        self.signinButton.clipsToBounds = true
        self.signinButton.setTitleColor(.white, for: .normal)
        self.signinButton.setTitle("LOGIN", for: .normal)
        
        self.forgotPassword.backgroundColor = .clear
        self.forgotPassword.setTitle("FORGOT PASSWORD?", for: .normal)
        self.forgotPassword.setTitleColor(.white, for: UIControl.State())
        self.forgotPassword.addTarget(self, action: #selector(forgotPasswordButtonAction), for: .touchUpInside)
        self.forgotPassword.titleLabel?.font = UIFont.montserratMedium
        
        self.emailTextField.setTextFieldImage(image: FAType.FAUser, direction: .right)
        self.emailTextField.keyboardType = .emailAddress
        self.passwordTextField.setTextFieldImage(image: FAType.FALock, direction: .right)
        self.passwordTextField.isSecureTextEntry = true
        
        self.emailTextField.setPlaceholder(placeholder: "User Name", color: UIColor.gray)
        self.passwordTextField.setPlaceholder(placeholder: "Password", color: UIColor.gray)
        
        self.emailTextField.textColor = .white
        self.passwordTextField.textColor = .white
        
        self.emailTextField.font = .montserratRegular
        self.passwordTextField.font = .montserratRegular
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.emailTextField.addButtomBorder()
        self.passwordTextField.addButtomBorder()
    }
    
   
    @objc func forgotPasswordButtonAction(){
        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        let navigationBar = UINavigationController(rootViewController: destination)
        navigationBar.modalPresentationStyle = .fullScreen
        self.present(navigationBar, animated: true, completion: nil)
    }
    @objc func signinButtonAction(){
        if (self.emailTextField.text?.isBlank ?? true){
            self.view.makeToast(message: "Please Enter Email ID", backgroundColor: nil, messageColor: .red)
        }
        else if (self.passwordTextField.text?.isBlank ?? true){
            self.view.makeToast(message: "Please Enter Password", backgroundColor: nil, messageColor: .red)
        }
        else{
            let bodyParams = [
                "username": self.emailTextField.text ?? "",
                "password": self.passwordTextField.text ?? ""
            ] as [String : String]
            self.activityIndicator.startAnimating()
            Alamofire.request((API_BASE_URL + "login"), method: .post, parameters: bodyParams).validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                self.activityIndicator.stopAnimating()
                
                print(resposeJSON)
                if(resposeJSON["status"] as? Int ?? 0) == 1{
                    let user = resposeJSON["user"] as? NSDictionary ?? NSDictionary()
                    let id = user["id"] as? String ?? "0"
                    let firstname = user["firstname"] as? String ?? ""
                    let lastname = user["lastname"] as? String ?? ""
                    let email = user["email"] as? String ?? ""
                    let image = user["image"] as? String ?? ""
                    let phone = user["phone"] as? String ?? ""
                    let user_group_id = user["user_group_id"] as? String ?? ""
                    //        email = "sid@testing.com";
                    let is_subscribed = user["is_subscribed"] as? Int ?? 0
                    
                    UserDefaults.standard.saveData(value: id, key: .userId)
                    UserDefaults.standard.saveData(value: firstname, key: .userFirstName)
                    UserDefaults.standard.saveData(value: lastname, key: .userLastName)
                    UserDefaults.standard.saveData(value: email, key: .userEmail)
                    UserDefaults.standard.saveData(value: phone, key: .userPhone)
                    UserDefaults.standard.saveData(value: image, key: .userImage)
                    UserDefaults.standard.saveData(value: user_group_id, key: .userGroupID)
                    
                    UserDefaults.standard.setValue(is_subscribed, forKey: "userSubscribed")
                    UserDefaults.standard.synchronize()
                    
                    //                    let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                    // self.appD.window?.rootViewController = destination
                    if is_subscribed == 0{
                        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navSub") as! UINavigationController
                        self.appD.window?.rootViewController = destination
                    }else{
                        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                        self.appD.window?.rootViewController = destination
                    }
                    
                }else{
                    self.view.makeToast(message: "Invalid Credential")
                }
            }
        }
    }
}
