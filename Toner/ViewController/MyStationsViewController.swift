//
//  MyStationsViewController.swift
//  Toner
//
//  Created by User on 26/09/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class MyStationsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var genreData = [Station]()
    var activityIndicator: NVActivityIndicatorView!
    var collectionViewWidth = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = ThemeColor.backgroundColor
        self.setNavigationBar(title: "MY STATION", isBackButtonRequired: true, isTransparent: false)
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        collectionViewWidth = (Double(self.collectionView.frame.width * 0.5) - 20.0)
        collectionView.dataSource   = self
        collectionView.delegate     = self
        collectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenreCollectionViewCell")
        collectionView.backgroundColor = .clear
        getAllStations()
    }
    
    fileprivate func getAllStations(){
        genreData.removeAll()
        let parameters = [
            "user_id": UserDefaults.standard.fetchData(forKey: .userId)
            ] as [String: String]
        self.activityIndicator.startAnimating()
        Alamofire.request("https://tonnerumusic.com/api/v1/member_station", method: .post, parameters: parameters, headers: nil).validate().responseJSON { (response) in
            
            guard response.result.isSuccess else {
                self.tabBarController?.view.makeToast(message: Message.apiError)
                self.activityIndicator.stopAnimating()
                return
            }
            
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            self.activityIndicator.stopAnimating()
            
            print(resposeJSON)
            let genres = resposeJSON["genres"] as? NSArray ?? NSArray()
            if genres.count > 0{
                genres.forEach { (genre) in
                    let currentGenre = genre as? NSDictionary ?? NSDictionary()
                    var genreData = Station()
                    genreData.id = currentGenre["id"] as? String ?? ""
                    genreData.name = currentGenre["name"] as? String ?? ""
                    genreData.icon = currentGenre["icon"] as? String ?? ""
                    genreData.color = currentGenre["color"] as? String ?? ""
                    
                    /*let songs = resposeJSON["songs"] as? NSArray ?? NSArray()
                    songs.forEach { (genreSong) in
                        let genreSong = genreSong as? NSDictionary ?? NSDictionary()
                        var curreentSong = StationSongs()
                        curreentSong.id = genreSong["id"] as? String ?? ""
                        curreentSong.album_id = genreSong["album_id"] as? String ?? ""
                        curreentSong.user_id = genreSong["user_id"] as? String ?? ""
                        curreentSong.package_id = genreSong["package_id"] as? String ?? ""
                        curreentSong.path = genreSong["path"] as? String ?? ""
                        curreentSong.name = genreSong["name"] as? String ?? ""
                        curreentSong.filetype = genreSong["filetype"] as? String ?? ""
                        curreentSong.filesize = genreSong["filesize"] as? String ?? ""
                        curreentSong.duration = genreSong["duration"] as? String ?? ""
                        curreentSong.image = genreSong["image"] as? String ?? ""
                        curreentSong.tag = genreSong["tag"] as? String ?? ""
                        curreentSong.description = genreSong["description"] as? String ?? ""
                        curreentSong.genre_id = genreSong["genre_id"] as? String ?? ""
                        curreentSong.lyrics = genreSong["lyrics"] as? String ?? ""
                        curreentSong.release_date = genreSong["release_date"] as? String ?? ""
                        curreentSong.allow_download = genreSong["allow_download"] as? String ?? ""
                        curreentSong.price = genreSong["price"] as? String ?? ""
                        curreentSong.sort_order = genreSong["sort_order"] as? String ?? ""
                        curreentSong.status = genreSong["status"] as? String ?? ""
                        curreentSong.date_added = genreSong["date_added"] as? String ?? ""
                        curreentSong.firstname = genreSong["firstname"] as? String ?? ""
                        genreData.songs.append(curreentSong)
                    }*/
                    self.genreData.append(genreData)
                }
            }
            
            self.collectionView.reloadData()
        }
    }
    
}

extension MyStationsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return genreData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as! GenreCollectionViewCell
        
        cell.setData(data: genreData[indexPath.item])
//        cell.contentView.layer.cornerRadius = 5
//        cell.contentView.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewWidth, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = StationListViewController(nibName: "StationListViewController", bundle: nil)
        destination.stationName = genreData[indexPath.item].name
        destination.stationID = genreData[indexPath.item].id
        self.navigationController?.pushViewController(destination, animated: true)
    }
}
