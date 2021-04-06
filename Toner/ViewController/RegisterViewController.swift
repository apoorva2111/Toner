//
//  RegisterViewController.swift
//  Toner
//
//  Created by User on 15/07/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var artistCheckBox: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
     @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
     @IBOutlet weak var confirmPasswordTextField: UITextField!

    @IBOutlet weak var signupButton: UIButton!

    var activityIndicator: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setNavigationBar(title: "", isBackButtonRequired: true)
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        self.signupButton.backgroundColor = ThemeColor.buttonColor
        self.signupButton.layer.cornerRadius = self.signupButton.frame.height / 2
        self.signupButton.clipsToBounds = true
        self.signupButton.setTitleColor(.white, for: .normal)
        self.signupButton.setTitle("REGISTER", for: .normal)
        self.signupButton.addTarget(self, action: #selector(self.signupButtonAction), for: .touchUpInside)
        
        self.artistCheckBox.setLeftImage(image: .FASquare, state: .normal)
        self.artistCheckBox.setLeftImage(image: .FACheckSquare, state: .selected)
        self.artistCheckBox.setTitle(" I am an artist, musicians, band, record label", for: UIControl.State())
        self.artistCheckBox.addTarget(self, action: #selector(self.artistCheckBoxAction(sender:)), for: .touchUpInside)
        
        
        self.firstNameTextField.setTextFieldImage(image: FAType.FAUser, direction: .right)
        self.lastNameTextField.setTextFieldImage(image: FAType.FAUser, direction: .right)
        self.emailTextField.setTextFieldImage(image: FAType.FAEnvelope, direction: .right)
        self.userNameTextField.setTextFieldImage(image: FAType.FAUser, direction: .right)
        self.passwordTextField.setTextFieldImage(image: FAType.FALock, direction: .right)
        self.confirmPasswordTextField.setTextFieldImage(image: FAType.FALock, direction: .right)
        
        self.firstNameTextField.setPlaceholder(placeholder: "First Name", color: UIColor.gray)
        self.lastNameTextField.setPlaceholder(placeholder: "Last Name", color: UIColor.gray)
        self.emailTextField.setPlaceholder(placeholder: "Email ID", color: UIColor.gray)
        self.userNameTextField.setPlaceholder(placeholder: "User Name", color: UIColor.gray)
        self.passwordTextField.setPlaceholder(placeholder: "Password", color: UIColor.gray)
        self.confirmPasswordTextField.setPlaceholder(placeholder: "Confirm Password", color: UIColor.gray)
        
        self.firstNameTextField.textColor = .white
        self.lastNameTextField.textColor = .white
        self.emailTextField.textColor = .white
        self.userNameTextField.textColor = .white
        self.passwordTextField.textColor = .white
        self.confirmPasswordTextField.textColor = .white
        
        self.firstNameTextField.font = .montserratRegular
        self.lastNameTextField.font = .montserratRegular
        self.emailTextField.font = .montserratRegular
        self.userNameTextField.font = .montserratRegular
        self.passwordTextField.font = .montserratRegular
        self.confirmPasswordTextField.font = .montserratRegular
        
        self.signupButton.titleLabel?.font = .montserratMedium
        self.artistCheckBox.titleLabel?.font = UIFont.montserratRegular.withSize(13)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.firstNameTextField.addButtomBorder()
        self.lastNameTextField.addButtomBorder()
        self.userNameTextField.addButtomBorder()
        self.emailTextField.addButtomBorder()
        self.passwordTextField.addButtomBorder()
        self.confirmPasswordTextField.addButtomBorder()
    }
    
    @objc func artistCheckBoxAction(sender: UIButton){
        self.artistCheckBox.isSelected = !self.artistCheckBox.isSelected
    }

    @objc func signupButtonAction(){
        if (self.firstNameTextField.text?.isBlank ?? true){
            self.view.makeToast(message: "Please Enter First Name", backgroundColor: nil, messageColor: .red)
        }
        else if (self.firstNameTextField.text?.isValidName ?? true){
            self.view.makeToast(message: "Invalid First Name", backgroundColor: nil, messageColor: .red)
        }
        
        else if (self.lastNameTextField.text?.isBlank ?? true){
            self.view.makeToast(message: "Please Enter Last Name", backgroundColor: nil, messageColor: .red)
        }
        else if (self.lastNameTextField.text?.isValidName ?? true){
            self.view.makeToast(message: "Invalid Last Name", backgroundColor: nil, messageColor: .red)
        }
        
        else if (self.emailTextField.text?.isBlank ?? true){
            self.view.makeToast(message: "Please Enter Email ID", backgroundColor: nil, messageColor: .red)
        }
        else if !(self.emailTextField.text?.isValidEmail ?? true){
            self.view.makeToast(message: "Invalid Email ID", backgroundColor: nil, messageColor: .red)
        }
        
        else if (self.userNameTextField.text?.isBlank ?? true){
            self.view.makeToast(message: "Please Enter User Name", backgroundColor: nil, messageColor: .red)
        }
      
        else if (self.passwordTextField.text?.isBlank ?? true){
            self.view.makeToast(message: "Please Enter Password", backgroundColor: nil, messageColor: .red)
        }
            
        else if (self.confirmPasswordTextField.text?.isBlank ?? true){
            self.view.makeToast(message: "Please Enter Confirm Password", backgroundColor: nil, messageColor: .red)
        }
        else if ((self.confirmPasswordTextField.text ?? "") != (self.passwordTextField.text ?? "") ){
            self.view.makeToast(message: "Passwords don't match.", backgroundColor: nil, messageColor: .red)
        }
        else{
            let firstName = self.firstNameTextField.text ?? ""
            let lastName = self.lastNameTextField.text ?? ""
            let email = self.emailTextField.text ?? ""
            let userName = self.userNameTextField.text ?? ""
            let password = self.passwordTextField.text ?? ""
            let isArtist = self.artistCheckBox.isSelected
            let bodyParams = [
                "firstname": firstName,
                "lastname": lastName,
                "email": email,
                "username": userName,
                "password": password,
                "artist": isArtist
                ] as [String : Any]
            print("parameters::\(bodyParams)")
            self.activityIndicator.startAnimating()
            Alamofire.request((API_BASE_URL + "register"), method: .post, parameters: bodyParams).validate().responseJSON { (response) in
                
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
                    
                    UserDefaults.standard.saveData(value: id, key: .userId)
                    UserDefaults.standard.saveData(value: firstname, key: .userFirstName)
                    UserDefaults.standard.saveData(value: lastname, key: .userLastName)
                    UserDefaults.standard.saveData(value: email, key: .userEmail)
                    UserDefaults.standard.saveData(value: phone, key: .userPhone)
                    UserDefaults.standard.saveData(value: image, key: .userImage)
                    UserDefaults.standard.saveData(value: user_group_id, key: .userGroupID)
                    UserDefaults.standard.synchronize()
                    
                    let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                    self.appD.window?.rootViewController = destination
                }else{
                    self.view.makeToast(message: "Invalid Credential")
                }
                
            }
            
        }
    }
}
