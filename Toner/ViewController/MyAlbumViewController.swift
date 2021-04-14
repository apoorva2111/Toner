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

class MyAlbumViewController: UIViewController{
    
   
    
    @IBOutlet weak var tblAlbums: UITableView!
    @IBOutlet weak var createAlbum: UIButton!
    var artistId: String!
    var activityIndicator: NVActivityIndicatorView!

    var arrAblum = [AlbumModel]()
    
   
    override func viewDidLoad() {
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        self.view.backgroundColor = ThemeColor.backgroundColor
        self.setNavigationBar(title: "MY ALBUM", isBackButtonRequired: true, isTransparent: false)
        tblAlbums.register(UINib(nibName: "PlayListTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayListTableViewCell")
        self.createAlbum.layer.cornerRadius = 10
        self.createAlbum.layer.masksToBounds = true
        tblAlbums.delegate = self
        tblAlbums.dataSource = self


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            let allAlbums = resposeJSON["albums"] as? NSArray ?? NSArray()
            if self.arrAblum.count>0{
                self.arrAblum.removeAll()
            }
            for objAlbum in allAlbums{
                let obj = objAlbum as? NSDictionary ?? NSDictionary()
                var currentData = AlbumModel()
                currentData.id = obj["id"] as? String ?? ""
                currentData.image = obj["image"] as? String ?? ""
                currentData.name = obj["name"] as? String ?? ""
                currentData.totalsongs = obj["totalsongs"] as? Int ?? 0
                currentData.user_id = obj["user_id"] as? String ?? ""
                self.arrAblum.append(currentData)
            }
            self.tblAlbums.reloadData()
            self.activityIndicator.stopAnimating()
           
        }
    }
    
    @IBAction func createAlbumAction(_ sender: Any) {
        let destination = CreatePlayListViewViewController(nibName: "CreatePlayListViewViewController", bundle: nil)
//        destination.modalPresentationStyle = .fullScreen
        destination.strCreate = "Album"
        destination.viewcontroller = self
       self.present(destination, animated: false, completion: nil)

    }
}

extension MyAlbumViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAblum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblAlbums.dequeueReusableCell(withIdentifier: "PlayListTableViewCell", for: indexPath) as! PlayListTableViewCell
        cell.backgroundColor = .clear
        cell.playListName.text = self.arrAblum[indexPath.row].name
        let strUrl = self.arrAblum[indexPath.row].image
        cell.playListImageView.kf.setImage(with: URL(string: strUrl ))
        cell.playListImageView.contentMode = .scaleToFill
        cell.deleteplayListButton.tag = indexPath.row

        
        cell.deleteplayListButton.tag = indexPath.row
        cell.editPlaylistButton.tag = indexPath.row
        cell.deleteplayListButton.addTarget(self, action: #selector(deleteAlbum), for: .touchUpInside)
        cell.editPlaylistButton.addTarget(self, action: #selector(editAlbum), for: .touchUpInside)
        cell.deleteplayListButton.isHidden = false
        cell.editPlaylistButton.isHidden = false
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destination = SongsInPlaylistViewController(nibName: "SongsInPlaylistViewController", bundle: nil)
        destination.plyalist_id = arrAblum[indexPath.row].id
        destination.playlist_name = arrAblum[indexPath.row].name
        destination.isFrom_Album = "Album"
        self.navigationController?.pushViewController(destination, animated: true)

    }
    
    
    @objc fileprivate func deleteAlbum(sender : UIButton){
        
        let alert = UIAlertController(
            title: "Delete Album!",
            message: "Are you sure want to delete this Album?",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.activityIndicator.startAnimating()
            self.deletePlaylistApiCAlled(sender.tag)
        })
        
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        self.present(
            alert,
            animated: true,
            completion: nil
        )
            
    }
    
    fileprivate func deletePlaylistApiCAlled(_ index : Int) {
        let bodyParams = [
            "album_id": self.arrAblum[index].id
            ] as [String : String]
        self.activityIndicator.startAnimating()
        Alamofire.request("https://tonnerumusic.com/api/v1/delete_album", method: .post, parameters: bodyParams).validate().responseJSON { (response) in
            
            guard response.result.isSuccess else {
                self.view.makeToast(message: Message.apiError)
                self.activityIndicator.stopAnimating()
                return
            }
            
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            showAlertForAlbum(message: resposeJSON["message"] as! String)
            self.getArtistAlbumData()
            self.activityIndicator.stopAnimating()
            print(resposeJSON)
        }
        func showAlertForAlbum(message: String) {
            let alert = UIAlertController(
                title: "Alert!",
                message: message,
                preferredStyle: UIAlertController.Style.alert
            )

            alert.addAction(UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default,
                handler: nil
            ))

            self.present(
                alert,
                animated: true,
                completion: nil
            )
        }
    }
    @objc fileprivate func editAlbum(sender : UIButton){
        
        //editAlbum
        let destination = CreatePlayListViewViewController(nibName: "CreatePlayListViewViewController", bundle: nil)
//        destination.modalPresentationStyle = .fullScreen
        destination.strCreate = "Album"
        destination.viewcontroller = self
        destination.album_id = arrAblum[sender.tag].id
        destination.album_name = arrAblum[sender.tag].name
        destination.album_image = arrAblum[sender.tag].image
       self.present(destination, animated: false, completion: nil)

    }
}
