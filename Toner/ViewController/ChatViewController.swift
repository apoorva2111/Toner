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
class ChatViewController: UIViewController {
 
    @IBOutlet weak var chatWebview: WKWebView!
    var artistId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callWebserviceFOrEndChat()
 self.setNavigationBar(title: "", isBackButtonRequired: true, isTransparent: false)

        WKWebViewRTC(wkwebview: chatWebview, contentController: chatWebview.configuration.userContentController)
        if UserDefaults.standard.fetchData(forKey: .userGroupID) == "3" {
            let userId : String = UserDefaults.standard.fetchData(forKey: .userId)
            chatWebview.load(URLRequest(url: URL(string:             "https://www.tonnerumusic.com/pages/chatroom?artist_id=\(userId)&chat=true")!))
            
            //"https://www.tonnerumusic.com/pages/chatroom?artist_id=\(userId)"
        }else{
            let userId : String = UserDefaults.standard.fetchData(forKey: .userId)
            chatWebview.load(URLRequest(url: URL(string:         "https://www.tonnerumusic.com/pages/chatroom?artist_id=\(artistId)&member_id=\(userId)&chat=true"
)!))
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        callWebserviceFOrEndChat()
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


