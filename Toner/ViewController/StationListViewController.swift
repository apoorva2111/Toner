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

class StationListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var artistData = [ArtistModel]()
    var activityIndicator: NVActivityIndicatorView!
    
    var stationName: String = ""
    var stationID: String = ""
    var songsList = [SongModel]()
    var playAllButton : UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        self.view.backgroundColor = ThemeColor.backgroundColor
        
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = ThemeColor.buttonColor
        self.setNavigationBar(title: stationName, isBackButtonRequired: true, isTransparent: false)
        playAllButton = UIBarButtonItem(title: "Play All", style: .plain, target: self, action: #selector(PlayAllClicked))
        self.navigationItem.rightBarButtonItems = [playAllButton]
        favButtonClicked()
        self.setNeedsStatusBarAppearanceUpdate()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ArtistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArtistCollectionViewCell")
        fetchGenereData(id: stationID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (TonneruMusicPlayer.player?.isPlaying ?? false){
         self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        }else{
            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc func PlayAllClicked(){
        resetPlayer()
        TonneruMusicPlayer.shared.initialize()
        TonneruMusicPlayer.shared.playSong(data: self.songsList, index: 0)
    }
    
    private func resetPlayer(){
        TonneruMusicPlayer.shared.currentIndex = -1
        TonneruMusicPlayer.shared.songList.removeAll()
        TonneruMusicPlayer.repeatMode = .off
        TonneruMusicPlayer.shuffleModeOn = false
        
       // self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 56))
    }
    
    @objc func favButtonClicked(){
        let parameters = [
            "member_id": UserDefaults.standard.fetchData(forKey: .userId),
            "genre_id" : stationID
            ] as [String: String]
        self.activityIndicator.startAnimating()
        Alamofire.request("https://tonnerumusic.com/api/v1/like_station", method: .post, parameters: parameters, headers: nil).validate().responseJSON { (response) in
            
            guard response.result.isSuccess else {
                self.tabBarController?.view.makeToast(message: Message.apiError)
                self.activityIndicator.stopAnimating()
                return
            }
            
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            self.activityIndicator.stopAnimating()
             let favStatus = resposeJSON["status"] as? Int ?? 0
            
            if favStatus == 1{
                let favButton = UIBarButtonItem(image: UIImage(icon: .FAHeart, size: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(self.favButtonClicked))
                self.navigationItem.rightBarButtonItems = [favButton,self.playAllButton]
            }
            else{
                let favButton = UIBarButtonItem(image: UIImage(icon: .FAHeartO, size: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(self.favButtonClicked))
                self.navigationItem.rightBarButtonItems = [favButton,self.playAllButton]
            }

        }
            
        
    }
    func fetchGenereData(id: String){
        self.activityIndicator.startAnimating()
        let reuestURL = "https://tonnerumusic.com/api/v1/genredetails?genre_id=\(id)"
        let urlConvertible = URL(string: reuestURL)!
        Alamofire.request(urlConvertible,
                          method: .get,
                          parameters: nil)
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                self.activityIndicator.stopAnimating()
                
                let genre = resposeJSON["genre"] as? NSDictionary ?? NSDictionary()
                
                let songDetails = genre["songs"] as? NSArray ?? NSArray()
                
                for data in songDetails {
                    let songData = data as? NSDictionary ?? NSDictionary()
                    let song_id = songData["id"] as? String ?? ""
                    let song_name = songData["name"] as? String ?? ""
                    let image = songData["image"] as? String ?? ""
                    let imagePath = "https://tonnerumusic.com/storage/uploads/" + image
                    let path = songData["path"] as? String ?? ""
                    let pathUrl = "https://tonnerumusic.com/storage/uploads/" + path
                    let fileType = songData["filetype"] as? String ?? ""
                    let duration = songData["duration"] as? String ?? ""
                    let fileSize = songData["filesize"] as? String ?? ""
                    
                    let songlist = SongModel(song_id: song_id, song_name: song_name, image: imagePath, path: pathUrl, filetype: fileType, filesize: fileSize, duration: duration, artist_name: "", artistImage: "")
                    self.songsList.append(songlist)
                }
                
                let newartists = resposeJSON["artists"] as? NSArray ?? NSArray()
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
                    
                    
                    
                    let artistData = ArtistModel(id: artistId, firstname: artistFirstName, lastname: artistLastName, email: artistEmail, username: artistUserName, phone: artistPhone, image: artistImage, type: artistType, is_online: "0")
                    self.artistData.append(artistData)
                }
                
                self.collectionView.reloadData()
        }
    }

}


extension StationListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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
        var cellWidth = 0.0
        if UIDevice.current.userInterfaceIdiom == .pad{
            cellWidth = Double((collectionView.bounds.width / 4) - 10)
        }else{
            cellWidth = Double((collectionView.bounds.width / 3) - 10)
        }
        return CGSize(width: cellWidth, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicListViewController") as! MusicListViewController
        destination.artistId = self.artistData[indexPath.item].id
        destination.artistType = self.artistData[indexPath.item].type
        self.navigationController!.pushViewController(destination, animated: true)
    }
}
