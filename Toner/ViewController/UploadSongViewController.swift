//
//  UploadSongViewController.swift
//  Toner
//
//  Created by Apoorva Gangrade on 26/04/21.
//  Copyright © 2021 Users. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class UploadSongViewController: UIViewController {
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var txtSongName: UITextField!
    @IBOutlet weak var txtStation: UITextField!
    @IBOutlet weak var txtReleaseDate: UITextField!
    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var txtAlbum: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtAllowDownload: UITextField!
    
    var activityIndicator: NVActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
    }
   
    func setUI() {
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        self.setNavigationBar(title: "Upload Song", isBackButtonRequired: true, isTransparent: false)

        
    }

   
}
