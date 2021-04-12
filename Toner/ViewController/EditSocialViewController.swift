//
//  EditSocialViewController.swift
//  Toner
//
//  Created by Mona on 13/10/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class EditSocialViewController: UIViewController {
    
    @IBOutlet weak var websiteText: UITextField!
    @IBOutlet weak var nuNetworkText: UITextField!
    @IBOutlet weak var twitterText: UITextField!
    @IBOutlet weak var youtubeText: UITextField!
    @IBOutlet weak var vimeoText: UITextField!
    @IBOutlet weak var instagramText: UITextField!
    @IBOutlet weak var tiktokText: UITextField!
    @IBOutlet weak var trillerText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ThemeColor.backgroundColor
        self.setNavigationBar(title: "Edit Social", isBackButtonRequired: true, isTransparent: false)
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        initialSetup()
        getSocialDetails()
        
    }
    
    func initialSetup(){
        setUpTextFields(websiteText, value: "", placeHolder: "Website")
        setUpTextFields(nuNetworkText, value: "", placeHolder: "NU Network")
        setUpTextFields(twitterText, value: "", placeHolder: "Twitter")
        setUpTextFields(youtubeText, value: "", placeHolder: "Youtube")
        setUpTextFields(vimeoText, value: "", placeHolder: "Vimeo")
        setUpTextFields(instagramText, value: "", placeHolder: "Instagram")
        setUpTextFields(tiktokText, value: "", placeHolder: "Tiktok")
        setUpTextFields(trillerText, value: "", placeHolder: "Triller")
        websiteText.setIcon(#imageLiteral(resourceName: "website"))
        youtubeText.setIcon(#imageLiteral(resourceName: "youtube"))
        nuNetworkText.setIcon(#imageLiteral(resourceName: "nu-network"))
        twitterText.setIcon(#imageLiteral(resourceName: "twitter"))
        instagramText.setIcon(#imageLiteral(resourceName: "instagram"))
        vimeoText.setIcon(#imageLiteral(resourceName: "vimeo"))
        tiktokText.setIcon(#imageLiteral(resourceName: "tiktok"))
        trillerText.setIcon(#imageLiteral(resourceName: "triller"))
        
        self.submitButton.backgroundColor = ThemeColor.buttonColor
        self.submitButton.layer.cornerRadius = self.submitButton.frame.height / 2
        self.submitButton.clipsToBounds = true
        self.submitButton.setTitleColor(.white, for: .normal)
        self.submitButton.setTitle("Submit", for: .normal)
        self.submitButton.addTarget(self, action: #selector(self.submitSocialInfo), for: .touchUpInside)
    }
    
    fileprivate func setUpTextFields(_ textField: UITextField, value: String, placeHolder: String){
        textField.text = value
        textField.setPlaceholder(placeholder: placeHolder, color: .gray)
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.font = .montserratRegular
        textField.tintColor = ThemeColor.buttonColor
        textField.addButtomBorder(color: UIColor.darkGray.cgColor)
    }
    
    @objc fileprivate func submitSocialInfo(){
        
        var parameters = [
            "website": websiteText.text ?? "",
            "nu": self.nuNetworkText.text ?? "",
            "twitter": self.twitterText.text ?? "",
            "youtube": self.youtubeText.text ?? "",
            "vimeo": self.vimeoText.text ?? "",
            "instagram": self.instagramText.text ?? "",
            "tiktok": self.tiktokText.text ?? "",
            "triller": self.trillerText.text ?? "",
        ] as [String: String]
        
        self.activityIndicator.startAnimating()
        let requestUrl = "https://tonnerumusic.com/api/v1/artist_social"
        parameters["artist_id"] = UserDefaults.standard.fetchData(forKey: .userId)
        
        Alamofire.request(requestUrl, method: .get, parameters: parameters)
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                self.activityIndicator.stopAnimating()
                let message = resposeJSON["message"] as? String ?? "Social Updated Successfully."
                self.showAlert(message: message)
                
        }
        
        
    }
    

    fileprivate func getSocialDetails(){
        //https://tonnerumusic.com/api/v1/artistdetails?artist_id=86
        let reuestURL = "https://tonnerumusic.com/api/v1/artistdetails?&artist_id=\(UserDefaults.standard.fetchData(forKey: .userId))"
        self.activityIndicator.startAnimating()
        Alamofire.request(reuestURL, method: .get, parameters: nil)
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                self.activityIndicator.stopAnimating()
                let artist = resposeJSON["artist"] as? NSDictionary ?? NSDictionary()
                let socialDetails = artist["social"] as? NSDictionary ?? NSDictionary()
                self.websiteText.text = socialDetails["website"] as? String ?? ""
                self.nuNetworkText.text = socialDetails["nu"] as? String ?? ""
                self.twitterText.text =  socialDetails["twitter"] as? String ?? ""
                self.youtubeText.text =  socialDetails["instagram"] as? String ?? ""
                self.vimeoText.text =  socialDetails["youtube"] as? String ?? ""
                self.instagramText.text =  socialDetails["vimeo"] as? String ?? ""
                self.tiktokText.text =  socialDetails["tiktok"] as? String ?? ""
                self.trillerText.text =  socialDetails["triller"] as? String ?? ""
        }

    }
}
