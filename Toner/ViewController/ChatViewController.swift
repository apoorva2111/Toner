//
//  ChatViewController.swift
//  Toner
//
//  Created by Apoorva Gangrade on 18/05/21.
//  Copyright © 2021 Users. All rights reserved.
//

import UIKit
import WebKit
import WKWebViewRTC
import Alamofire
import SafariServices

class ChatViewController: UIViewController {
 
    @IBOutlet weak var chatWebview: WKWebView!
    var artistId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        WKWebViewRTC(wkwebview: chatWebview, contentController: chatWebview.configuration.userContentController)
      
        self.setNavigationBar(title: "", isBackButtonRequired: true, isTransparent: false)

        if UserDefaults.standard.fetchData(forKey: .userGroupID) == "3" {
            let userId : String = UserDefaults.standard.fetchData(forKey: .userId)
         chatWebview.load(URLRequest(url: URL(string:             "https://www.tonnerumusic.com/pages/chatroom?artist_id=\(userId)&chat=true")!))
            
            //chatWebview.load(URLRequest(url: URL(string:             "https://www.tonnerumusic.com/pages/chatroom?artist_id=142&chat=true")!))

            //"https://www.tonnerumusic.com/pages/chatroom?artist_id=\(userId)"
        }else{
            let userId : String = UserDefaults.standard.fetchData(forKey: .userId)
        chatWebview.load(URLRequest(url: URL(string:         "https://www.tonnerumusic.com/pages/chatroom?artist_id=\(artistId)&member_id=\(userId)&chat=true")!))
   
            //chatWebview.load(URLRequest(url: URL(string:         "https://www.tonnerumusic.com/pages/chatroom?artist_id=142&member_id=48&chat=true")!))
            
//            guard let url = URL(string: "https://www.tonnerumusic.com/pages/chatroom?artist_id=142&member_id=48&chat=true") else{ return }
//          let safariVC = SFSafariViewController(url: url)
//            self.present(safariVC, animated: true, completion: nil)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
   //     if UserDefaults.standard.fetchData(forKey: .userGroupID) == "3" {
            callWebserviceFOrEndChat()
   //     }
    }

    func callWebserviceFOrEndChat(){
//        self.activityIndicator.startAnimating()
        
        let bodyParams = ["user_id": UserDefaults.standard.fetchData(forKey: .userId)] as [String : String]
//        self.activityIndicator.startAnimating()
        Alamofire.request("https://tonnerumusic.com/api/v1/endchatroom", method: .post, parameters: bodyParams).validate().responseJSON { (response) in
            
            guard response.result.isSuccess else {
                self.view.makeToast(message: Message.apiError)
               // self.activityIndicator.stopAnimating()
                return
            }
            
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
           // self.activityIndicator.stopAnimating()
            
            print(resposeJSON)
           
            }
           
        }
    }


