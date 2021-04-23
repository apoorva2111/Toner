//
//  StationListViewController.swift
//  Toner
//
//  Created by User on 26/07/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Kingfisher

class FollowingsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var artistData = [ArtistModel]()
    var activityIndicator: NVActivityIndicatorView!
    
    var stationName: String = ""
    var stationID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        self.view.backgroundColor = ThemeColor.backgroundColor
        
        self.navigationController?.navigationBar.barTintColor = .black
        self.setNavigationBar(title: "FOLLOWING", isBackButtonRequired: true, isTransparent: false)
        self.setNeedsStatusBarAppearanceUpdate()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ArtistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArtistCollectionViewCell")
        fetchGenereData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchGenereData), name: .UpdateFollowingList, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (TonneruMusicPlayer.player?.isPlaying ?? false){
         self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        }else{
            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc func fetchGenereData(){
        self.activityIndicator.startAnimating()
        let parameter = [
            "user_id": UserDefaults.standard.fetchData(forKey: .userId)
        ] as [String: String]
        let reuestURL = "https://tonnerumusic.com/api/v1/memberfollowedartist"
        Alamofire.request(reuestURL, method: .post, parameters: parameter)
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                print(resposeJSON)
                self.activityIndicator.stopAnimating()
                
                let newartists = resposeJSON["followed"] as? NSArray ?? NSArray()
                for data in newartists{
                    let newartist = data as? NSDictionary ?? NSDictionary()
                    let artistId = newartist["id"] as? String ?? ""
                    let artistFirstName = newartist["firstname"] as? String ?? ""
                    let artistLastName = newartist["lastname"] as? String ?? ""
                    let artistEmail = newartist["email"] as? String ?? ""
                    let artistUserName = newartist["username"] as? String ?? ""
                    let artistPhone = newartist["phone"] as? String ?? ""
                    let artistImage = newartist["image"] as? String ?? ""
                    let artistType = newartist["type"] as? String ?? ""
                    
                    let artistData = ArtistModel(id: artistId, firstname: artistFirstName, lastname: artistLastName, email: artistEmail, username: artistUserName, phone: artistPhone, image: artistImage, type: artistType)
                    self.artistData.append(artistData)
                }
                
                self.collectionView.reloadData()
        }
    }

}


extension FollowingsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artistData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCollectionViewCell", for: indexPath) as! ArtistCollectionViewCell
        cell.setData(data: artistData[indexPath.item])
        cell.artistImage.layer.cornerRadius = 10
        cell.artistImage.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     //   var cellWidth = 0.0
//        if UIDevice.current.userInterfaceIdiom == .pad{
//            cellWidth = Double((collectionView.bounds.width / 4) - 10)
//        }else{
//            cellWidth = Double((collectionView.bounds.width / 3) - 10)
//        }
//        return CGSize(width: cellWidth, height: 170)
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (self.collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicListViewController") as! MusicListViewController
        destination.artistId = self.artistData[indexPath.item].id
        destination.artistType = self.artistData[indexPath.item].type
        self.navigationController!.pushViewController(destination, animated: true)
    }
}
