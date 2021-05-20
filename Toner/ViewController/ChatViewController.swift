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

class ChatViewController: UIViewController {
 
    @IBOutlet weak var chatWebview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar(title: "", isBackButtonRequired: true, isTransparent: false)

        WKWebViewRTC(wkwebview: chatWebview, contentController: chatWebview.configuration.userContentController)
        let userId : String = UserDefaults.standard.fetchData(forKey: .userId)
        chatWebview.load(URLRequest(url: URL(string: "https://www.tonnerumusic.com/pages/chatroom?artist_id=\(userId)")!))

    }
    

   

}
