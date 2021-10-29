//
//  SupportAndHelpViewController.swift
//  Toner
//
//  Created by Apoorva Gangrade on 07/06/21.
//  Copyright © 2021 Users. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire
class SupportAndHelpViewController: UIViewController, MFMailComposeViewControllerDelegate
{
    
    @IBAction func btnContactUsAction(_ sender: UIButton) {
        if sender.tag == 10{
            
            let mailComposeViewController = configureMailComposer()
              if MFMailComposeViewController.canSendMail(){
                  self.present(mailComposeViewController, animated: true, completion: nil)
              }else{
                  print("Can't send email")
              }
        }else{
            
            let mailComposeViewController = configureMailInfoComposer()
              if MFMailComposeViewController.canSendMail(){
                  self.present(mailComposeViewController, animated: true, completion: nil)
              }else{
                  print("Can't send email")
              }
        }
    }
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["support@tonnerumusic.com"])
        mailComposeVC.setSubject("Contact TON'NERU MUSIC")
        mailComposeVC.setMessageBody("", isHTML: false)
        return mailComposeVC
    }
    func configureMailInfoComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["info@tonnerumusic.com"])
        mailComposeVC.setSubject("Contact TON'NERU MUSIC")
        mailComposeVC.setMessageBody("", isHTML: false)
        return mailComposeVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
myplans()
        // Do any additional setup after loading the view.
    }
    
    func myplans(){
        let reuestURL = "https://tonnerumusic.com/api/v1/myplans"
        let urlConvertible = URL(string: reuestURL)!
        Alamofire.request(urlConvertible,
                          method: .post,
                          parameters: [
                            "user_id": UserDefaults.standard.fetchData(forKey: .userId)
                          ] as [String: String])
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                print(resposeJSON)
                
                if(resposeJSON["status"] as? Bool ?? false){
                    
                }else{
                    let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
                    self.navigationController?.pushViewController(destination, animated: true)
                    
                }
            }
    }

    //MARK: - MFMail compose method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
  
}
