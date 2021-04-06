//
//  AddToPlayListViewController.swift
//  CollectionViewShelfLayout
//
//  Created by Muvi on 31/08/17.
//  Copyright © 2017 Pitiphong Phongpattranont. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class AddToPlayListViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var miniView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playListTitle: UILabel!
    @IBOutlet weak var addToPlayListLabel: UILabel!
    
   
   var activityIndicator: NVActivityIndicatorView!
   var playListData = [PlayListModel]()
   var songId = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
         self.tableView.register(UINib(nibName:"PlayListCells",bundle:nil), forCellReuseIdentifier: "PlayListCells")
        self.view.backgroundColor = .clear
        self.tableView.backgroundColor = ThemeColor.backgroundColor
        
        
        
        //gets here
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismisss))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        self.addToPlayListLabel.text = "Add to Playlist"
        self.addToPlayListLabel.textColor = .white
        self.addToPlayListLabel.textAlignment = .center
        self.addToPlayListLabel.font = UIFont.montserratMedium.withSize(20)
       
                //notification for showAllPlayList observe here
        NotificationCenter.default.addObserver(self, selector: #selector(self.allPlayListFuncPageRelod), name: NSNotification.Name(rawValue: "showAllPlayList"), object: nil)
        
        self.miniView.backgroundColor = ThemeColor.backgroundColor
        self.miniView.layer.borderColor = ThemeColor.buttonColor.cgColor
        self.miniView.layer.borderWidth = 2
        self.miniView.layer.cornerRadius = 20
        
        self.tableView.layer.borderColor = ThemeColor.subHeadingColor.cgColor
       // self.tableView.layer.borderWidth = 1
      //  self.tableView.layer.cornerRadius = 20
        self.tableView.backgroundColor = ThemeColor.backgroundColor
       
        self.allPlayListFunc()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: self.miniView))!
        {
            return false
        }
        return true
    }
    
    @objc func allPlayListFuncPageRelod()
    {
         self.allPlayListFunc()
    }
    
   @objc func dismisss()
    {
        self.dismiss(animated: false, completion: nil)
    }
    
   

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func addToPlaylistContentAPI()
    {
            
    }
    
    func showAlertForPlaylist(message: String) {
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

extension AddToPlayListViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayListCells", for: indexPath) as! PlayListCells
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = ThemeColor.backgroundColor
            }
            else
            {
                cell.backgroundColor = #colorLiteral(red: 0.2, green: 0.1960784314, blue: 0.2, alpha: 1)
            }
        cell.songName.text = self.playListData[indexPath.row].name.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.lblPlayListCount.text = self.playListData[indexPath.row].totalsongs
        cell.images.kf.setImage(with: URL(string: self.playListData[indexPath.row].image))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        addToPlayListApi(songId: self.songId, playlistId: self.playListData[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            return 75
        }
        else{
            return 75
        }
    }
    
}

//MARK:- API CALLS
extension AddToPlayListViewController {
    func allPlayListFunc()
    {
        self.playListData.removeAll()
        self.activityIndicator.startAnimating()
        let bodyParams = [
            "user_id": UserDefaults.standard.fetchData(forKey: .userId)
            ] as [String : String]
        self.activityIndicator.startAnimating()
//        Alamofire.request("https://tonnerumusic.com/api/v1/memberplaylist", method: .post, parameters: bodyParams).validate().responseJSON { (response) in
            
        Alamofire.request("https://tonnerumusic.com/api/v1/memberplaylist", method: .post, parameters: [:]).validate().responseJSON { (response) in
            guard response.result.isSuccess else {
                self.view.makeToast(message: Message.apiError)
                self.activityIndicator.stopAnimating()
                return
            }
            
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            self.activityIndicator.stopAnimating()
            
            print(resposeJSON)
            let playlists = resposeJSON["playlists"] as? NSArray ?? NSArray()
            if playlists.count > 0{
                playlists.forEach { (playList) in
                    let currentPlayList = playList as? NSDictionary ?? NSDictionary()
                    var playListData = PlayListModel()
                    playListData.id = currentPlayList["id"] as? String ?? ""
                    playListData.user_id = currentPlayList["user_id"] as? String ?? ""
                    playListData.member_name = currentPlayList["member_name"] as? String ?? ""
                    playListData.name = currentPlayList["name"] as? String ?? ""
                    playListData.totalsongs = String(currentPlayList["totalsongs"] as? Int ?? 0)
                    playListData.image = currentPlayList["image"] as? String ?? ""
                    self.playListData.append(playListData)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func addToPlayListApi(songId : String , playlistId : String , user_id : String = UserDefaults.standard.fetchData(forKey: .userId) ){
        
        //https://tonnerumusic.com/api/v1/addtoplaylist
        self.activityIndicator.startAnimating()
        let bodyParams = [
            "user_id"    : user_id,
            "song_id"    : songId ,
            "playlist_id": playlistId
            ] as [String : String]
        self.activityIndicator.startAnimating()
        
        Alamofire.request("https://tonnerumusic.com/api/v1/addtoplaylist", method: .post, parameters: bodyParams).validate().responseJSON { (response) in
            
            guard response.result.isSuccess else {
                self.view.makeToast(message: Message.apiError)
                self.activityIndicator.stopAnimating()
                return
            }
            
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            self.activityIndicator.stopAnimating()
            self.showAlertForPlaylist(message: resposeJSON["message"] as! String)
            print(resposeJSON)

            self.allPlayListFunc()
            
        }
    }
    
    
}
