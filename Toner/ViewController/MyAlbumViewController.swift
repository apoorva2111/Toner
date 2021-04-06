//
//  MyAlbumViewController.swift
//  Toner
//
//  Created by Muvi on 16/03/21.
//  Copyright © 2021 Users. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import NVActivityIndicatorView

class MyAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
    
    @IBOutlet weak var createAlbum: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var artistId: String!
    var activityIndicator: NVActivityIndicatorView!
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//      return UICollectionViewCell?
//    }
    @IBAction func createAlbumAction(_ sender: Any) {
        let destination = CreatePlayListViewViewController(nibName: "CreatePlayListViewViewController", bundle: nil)
        self.modalPresentationStyle = .fullScreen
       self.present(destination, animated: false, completion: nil)
       // createAlbumFun()
    }
   
    override func viewDidLoad() {
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        self.view.backgroundColor = ThemeColor.backgroundColor
        self.setNavigationBar(title: "MY ALBUM", isBackButtonRequired: true, isTransparent: false)
//        collectionView.dataSource   = self
//        collectionView.delegate     = self
//        collectionView.backgroundColor = .clear
        getArtistAlbumData()
    }
    func getArtistAlbumData(){
        self.activityIndicator.startAnimating()
        self.artistId = UserDefaults.standard.fetchData(forKey: .userId)
        let apiURL = "https://tonnerumusic.com/api/v1/artist_album"
        let urlConvertible = URL(string: apiURL)!
        Alamofire.request(urlConvertible,
                      method: .post,
                      parameters: [
                        "artist_id": artistId ?? ""
            ] as [String: String])
        .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                     self.activityIndicator.stopAnimating()
                    return
                }
                
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            print(resposeJSON)
            self.activityIndicator.stopAnimating()
            
            
            let results = resposeJSON["text"] as? String ?? ""
            
         
            
           // NotificationCenter.default.post(name: .UpdateFollowingList, object: nil)
           
           // self.collectionView.reloadData()
        }
    }
}

