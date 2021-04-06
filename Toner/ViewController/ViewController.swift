//
//  ViewController.swift
//  Toner
//
//  Created by Users on 06/11/19.
//  Copyright © 2019 Users. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var alreadyUser: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signupButton.addTarget(self, action: #selector(self.registerButtonAction), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(self.loginButtonAction), for: .touchUpInside)
        signupButton.titleLabel?.font = UIFont.montserratRegular.withSize(14)
        loginButton.titleLabel?.font = UIFont.montserratRegular.withSize(14)
        alreadyUser.font = UIFont.montserratRegular
    }
    
    @objc func gotoPlayerPage(){
        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        self.appD.window?.rootViewController = destination
    }
    
    @objc func loginButtonAction(){
        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navigationBar = UINavigationController(rootViewController: destination)
        navigationBar.modalPresentationStyle = .fullScreen
        self.present(navigationBar, animated: true, completion: nil)
    }
    
    @objc func registerButtonAction(){
        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        let navigationBar = UINavigationController(rootViewController: destination)
        navigationBar.modalPresentationStyle = .fullScreen
        self.present(navigationBar, animated: true, completion: nil)
    }


}

