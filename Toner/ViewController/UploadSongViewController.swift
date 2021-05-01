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
import AVFoundation
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
    var url : URL?
    
    @IBAction func btnPublishAction(_ sender: UIButton) {
    }
    @IBAction func btnSelectImgAction(_ sender: UIButton) {
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
     // Do any additional setup after loading the view.
        setUI()
        let playerItem = AVPlayerItem(url: url!)
        let metadataList = playerItem.asset.commonMetadata


            for item in metadataList {
                if let stringValue = item.value as? String {
                    if item.commonKey?.rawValue == "title" {
                        print(stringValue)
                        lblSongName.text = stringValue
                        txtSongName.text = stringValue
                    }
                   
                }
            }
    }
   
    func setUI() {
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        self.setNavigationBar(title: "Upload Song", isBackButtonRequired: true, isTransparent: false)

        
    }

    //        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypeAudio)], in: .import)
    //            importMenu.delegate = self
    //            importMenu.modalPresentationStyle = .formSheet
    //            self.present(importMenu, animated: true, completion: nil)
     
}

extension UploadSongViewController : UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate{
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)

    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
    }
          

//    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
//        documentPicker.delegate = self
//        present(documentPicker, animated: true, completion: nil)
//    }


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
}



/*
 uploadsong (POST)

 BODY

 "user_id"=>100,
 "album_id"=>1,
 "image"=>'thumbnail image',
 "track"=>'song strack',
 "release_date"=>'release_date',
 "price"=>'price',
 "allow_download"=>'allow_download', (should be 1 or 0)
 */
