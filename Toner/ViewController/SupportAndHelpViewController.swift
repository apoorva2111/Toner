//
//  SupportAndHelpViewController.swift
//  Toner
//
//  Created by Apoorva Gangrade on 07/06/21.
//  Copyright © 2021 Users. All rights reserved.
//

import UIKit
import MessageUI

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

        // Do any additional setup after loading the view.
    }

    //MARK: - MFMail compose method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
  
}
