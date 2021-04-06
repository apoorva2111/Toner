//
//  AcountOverviewViewController.swift
//  Toner
//
//  Created by Apoorva Gangrade on 26/03/21.
//  Copyright © 2021 Users. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class AcountOverviewViewController: UIViewController {
    @IBOutlet weak var lblProfileHeader: UILabel!
    @IBOutlet weak var viewEditProfile: UIView!
    @IBOutlet weak var btnOutletEditProfile: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblFullSupport: UILabel!
    @IBOutlet weak var lbluploadSong: UILabel!
    @IBOutlet weak var lblSongDownloadtext: UILabel!
    @IBOutlet weak var viewMyPlan: UIView!

    var activityIndicator: NVActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = ThemeColor.backgroundColor
        self.setNavigationBar(title: "Account Overview", isBackButtonRequired: true, isTransparent: false)
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        viewEditProfile.layer.cornerRadius = 5
        viewEditProfile.layer.borderWidth = 1
        viewEditProfile.layer.borderColor = #colorLiteral(red: 0.8917034268, green: 0.7353211045, blue: 0.2848914862, alpha: 1)
        viewEditProfile.layer.masksToBounds = true
        viewMyPlan.layer.cornerRadius = 5
        viewMyPlan.clipsToBounds = true
        
        
        
        
//        let font = UIFont(name: "Montserrat-Regular", size: 13)!
//        let boldFont = UIFont(name: "Montserrat-Bold", size: 13)
//        lblSongDownloadtext.attributedText = "Song download free, and access to the Website and Add (LIMITED TIME)".withBoldText(
//            boldPartsOfString: ["(LIMITED TIME)"], font: font, boldFont: boldFont)

    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfileDetails()

    }
    
    fileprivate func getProfileDetails(){
        let parameters = [
            "user_id": UserDefaults.standard.fetchData(forKey: .userId)
            ] as [String: String]
        
        self.activityIndicator.startAnimating()
        let reuestURL = "https://www.tonnerumusic.com/api/v1/member_profile"
        
        Alamofire.request(reuestURL, method: .post, parameters: parameters)
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                self.activityIndicator.stopAnimating()
                let memberJSON = resposeJSON["memberinfo"] as? NSDictionary ?? NSDictionary()
               self.lblUsername.text = memberJSON["username"] as? String ?? ""
                self.lblFirstName.text = (memberJSON["firstname"] as? String ?? "") + " " + (memberJSON["lastname"] as? String ?? "")
                self.lblEmail.text = memberJSON["email"] as? String ?? ""
                self.lblPhone.text = memberJSON["phone"] as? String ?? ""
                self.lblGender.text = memberJSON["gender"] as? String ?? "male"
                self.lblCountry.text = memberJSON["country"] as? String ?? ""
        
    }
    }
    @IBAction func btnEdiProfileAction(_ sender: UIButton) {
        let destination = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(destination, animated: false)

    }
}
extension String {
    func withBoldText(boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedString.Key.font:font!]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont]
        let boldString = NSMutableAttributedString(string: self as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute as [NSAttributedString.Key : Any], range: (self as NSString).range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
}
