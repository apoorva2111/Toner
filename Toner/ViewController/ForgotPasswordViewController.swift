//
//  ForgotPasswordViewController.swift
//  Toner
//
//  Created by User on 22/08/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    
    var activityIndicator: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        self.setNavigationBar(title: "", isBackButtonRequired: true)
        
        self.emailTextField.setPlaceholder(placeholder: "Email Address", color: UIColor.gray)
        self.emailTextField.setTextFieldImage(image: FAType.FAUser, direction: .right)
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.textColor = .white
        
        self.signinButton.backgroundColor = ThemeColor.buttonColor
        self.signinButton.layer.cornerRadius = self.signinButton.frame.height / 2
        self.signinButton.clipsToBounds = true
        self.signinButton.setTitleColor(.white, for: .normal)
        self.signinButton.setTitle("Submit", for: .normal)
        
        signinButton.addTarget(self, action: #selector(self.submitButtonAction), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.emailTextField.addButtomBorder()
    }
    
    @objc func submitButtonAction(){
        if (self.emailTextField.text?.isBlank ?? true){
            self.view.makeToast(message: "Please Enter Email ID", backgroundColor: nil, messageColor: .red)
            return
        }
        self.activityIndicator.startAnimating()
        let bodyParams = [
            "email": self.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        ] as [String : String]
        Alamofire.request("https://tonnerumusic.com/api/v1/forgotpassword", method: .post, parameters: bodyParams).validate().responseJSON { (response) in
            
            guard response.result.isSuccess else {
                self.view.makeToast(message: Message.apiError)
                self.activityIndicator.stopAnimating()
                return
            }
            
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            self.activityIndicator.stopAnimating()
            
            print(resposeJSON)
            if(resposeJSON["status"] as? Int ?? 0) == 1{
                //Success Action
              if let msg = resposeJSON["message"] as? String{
                let alertController = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)

                    // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        self.dismiss(animated: true, completion: nil)
                    }
                    

                    // Add the actions
                    alertController.addAction(okAction)

                    // Present the controller
                self.present(alertController, animated: true, completion: nil)              }
            }else{
                let error = resposeJSON["warning"] as? String ?? ""
                self.view.makeToast(message: error)
            }

        }
    }

}
