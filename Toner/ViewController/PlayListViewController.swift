//
//  PlayListViewController.swift
//  Toner
//
//  Created by User on 12/09/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class PlayListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblPlaylist: UILabel!
    @IBOutlet weak var btnPlaylistOutlet: UIButton!
  
    @IBOutlet weak var lblDownload: UILabel!
    @IBOutlet weak var btnDownloadOutlet: UIButton!

    var activityIndicator: NVActivityIndicatorView!
    var offlineData = [ContentDetailsEntityModel]()

    var playListData = [PlayListModel]()
    var isSelectedTab = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setNavigationBar(title: "My Library", isBackButtonRequired: false, isTransparent: false)

        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        self.view.backgroundColor = ThemeColor.backgroundColor
        
        self.navigationController?.navigationBar.barTintColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PlayListTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayListTableViewCell")
        tableView.register(UINib(nibName: "DownloadTableViewCell", bundle: nil), forCellReuseIdentifier: "DownloadTableViewCell")

        NotificationCenter.default.addObserver(self, selector: #selector(getAllPlayList), name: Notification.Name("reloadPlaylist"), object: nil)
    }
    
    func myplans(){
        let reuestURL = "https://tonnerumusic.com/api/v1/myplans"
        let urlConvertible = URL(string: reuestURL)!
        Alamofire.request(urlConvertible,
                          method: .post,
                          parameters: [
                            "user_id": UserDefaults.standard.fetchData(forKey: .userId)
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
                
                if(resposeJSON["status"] as? Bool ?? false){
                    self.getAllPlayList()
                }else{
                    let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        myplans()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc
    fileprivate func getAllPlayList(){
        self.playListData.removeAll()
        self.activityIndicator.startAnimating()
        let bodyParams = [
            "user_id": UserDefaults.standard.fetchData(forKey: .userId)
            ] as [String : String]
        self.activityIndicator.startAnimating()
        Alamofire.request("https://tonnerumusic.com/api/v1/memberplaylist", method: .post, parameters: bodyParams).validate().responseJSON { (response) in
            
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
                    playListData.totalsongs = currentPlayList["totalsongs"] as? String ?? ""
                    playListData.image = currentPlayList["image"] as? String ?? ""
                    self.playListData.append(playListData)
                }
                self.isSelectedTab = true
            }
            self.tableView.reloadData()
        }
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
    
    fileprivate func deletePlaylistApiCAlled(_ index : Int) {
        let bodyParams = [
            "playlist_id": self.playListData[index].id
            ] as [String : String]
        self.activityIndicator.startAnimating()
        Alamofire.request("https://tonnerumusic.com/api/v1/playlistdelete", method: .post, parameters: bodyParams).validate().responseJSON { (response) in
            
            guard response.result.isSuccess else {
                self.view.makeToast(message: Message.apiError)
                self.activityIndicator.stopAnimating()
                return
            }
            
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            self.showAlertForPlaylist(message: resposeJSON["message"] as! String)
            self.getAllPlayList()
            self.activityIndicator.stopAnimating()
            print(resposeJSON)
            
            
        }
    }
    
    @objc fileprivate func deletePlaylist(sender : UIButton){
        
        let alert = UIAlertController(
            title: "Delete Playlist!",
            message: "Are you sure want to delete this playlist?",
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
    
    fileprivate func editPlaylistApiCalled(_ sender: UIButton,_ newPlaylistName : String) {
        let bodyParams = [
            "playlist_id"   : self.playListData[sender.tag].id,
            "user_id"       : UserDefaults.standard.fetchData(forKey: .userId),
            "playlist_name" : newPlaylistName
            ] as [String : String]
        self.activityIndicator.startAnimating()
        Alamofire.request("https://tonnerumusic.com/api/v1/playlistedit", method: .post, parameters: bodyParams).validate().responseJSON { (response) in
            
            guard response.result.isSuccess else {
                self.view.makeToast(message: Message.apiError)
                self.activityIndicator.stopAnimating()
                return
            }
            
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            self.showAlertForPlaylist(message: resposeJSON["message"] as! String)
            self.getAllPlayList()
            self.activityIndicator.stopAnimating()
            print(resposeJSON)
        }
    }
    
    @objc fileprivate func editPlaylist(sender : UIButton){
        let objPalyList = playListData[sender.tag]
        let alert = UIAlertController(title: "Edit Playlist Name", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
           // textField.placeholder = "New playlist name"
            textField.text = objPalyList.name
        }


        let submitAction = UIAlertAction(title: "Change", style: .default) { [unowned alert] _ in
            let newPlaylistName = alert.textFields![0].text
            
            if (newPlaylistName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ?? true{
                self.tabBarController?.view.makeToast(message: "Playlist name should not be blank")
            }else{
                self.editPlaylistApiCalled(sender,newPlaylistName!)
            }
        }

        alert.addAction(submitAction)
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        present(alert, animated: true)
    }
    fileprivate func resetPlayer(){
        TonneruMusicPlayer.shared.currentIndex = -1
        TonneruMusicPlayer.shared.songList.removeAll()
        TonneruMusicPlayer.repeatMode = .off
        TonneruMusicPlayer.shuffleModeOn = false
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 88))
    }
}
//MARK:- Download Song
extension PlayListViewController{
    fileprivate func fetchOfflineData(){
        let allDownloadedContent = ContentDetailsEntity.fetchData()
        offlineData = allDownloadedContent.map { (currentData) -> ContentDetailsEntityModel in
            var currentDownloadData = currentData
            currentDownloadData.songImage = DownloadDirectory.images?.appendingPathComponent(currentData.songImage).path ?? ""
            currentDownloadData.artistImage = DownloadDirectory.images?.appendingPathComponent(currentData.artistImage).path ?? ""
            currentDownloadData.songPath = DownloadDirectory.audios?.appendingPathComponent(currentData.songPath).path ?? ""
            currentDownloadData.fileSize = ByteCountFormatter.string(fromByteCount: Int64(currentData.fileSize) ?? 0, countStyle: .file)
            return currentDownloadData
        }
        let currentDownloadData = CurrentDownloadEntity.fetchData()
//        offlineData.removeAll { (offlineDat) -> Bool in
//            return currentDownloadData.contains(where: {$0.contentDetails.songID == offlineDat.songID})
//        }
        tableView.reloadData()
        self.activityIndicator.stopAnimating()

        if offlineData.count == 0{
            let alertController = UIAlertController(title: "Alert!", message: "No songs found in offline.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc
    fileprivate func deleteAction(sender: UIButton){
        if TonneruMusicPlayer.shared.songList.count > 0 && TonneruMusicPlayer.shared.currentIndex > -1 && TonneruMusicPlayer.shared.songList.count > TonneruMusicPlayer.shared.currentIndex{
            let currentPlayingSongID = TonneruMusicPlayer.shared.songList[TonneruMusicPlayer.shared.currentIndex].song_id
            if self.offlineData[sender.tag].songID == currentPlayingSongID && TonneruMusicPlayer.shared.isMiniViewActive {
                self.showAlert(message: "You can not delete the song as it is playing now.")
                return
            }
        }
        
        let alertController = UIAlertController(title: "Alert!", message: "Are you sure you want to delete the downloaded song?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            let currentDownloadData = self.offlineData[sender.tag].songID
            self.deleteSongFromServer(songId: currentDownloadData)
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteSongFromServer(songId: String){
        Alamofire.request(URL(string: "https://tonnerumusic.com/api/v1/removesongfromdownloads")!,
                          method: .post,
                          parameters: [
                            "user_id": UserDefaults.standard.fetchData(forKey: .userId),
                            "song_id": songId
                          ] as [String: String])
            .validate().responseJSON { (response) in
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                if resposeJSON["status"] as? Bool == true{
                    self.tabBarController?.view.makeToast(message: resposeJSON["message"] as! String)
                    ContentDetailsEntity.delete(songId: songId)
                    self.fetchOfflineData()
                }
            }
    }

}
//MARK:- UIButton Action
extension PlayListViewController{
    @IBAction func btnSwitchPageAction(_ sender: UIButton) {
        if sender.tag == 10 {
            btnPlaylistOutlet.setTitleColor(.white, for: .normal)
            lblPlaylist.backgroundColor = #colorLiteral(red: 0.9259513617, green: 0.7214286327, blue: 0.1487246752, alpha: 1)
          
            btnDownloadOutlet.setTitleColor(#colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), for: .normal)
            lblDownload.backgroundColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
            isSelectedTab = true
            self.tableView.reloadData()
        }else{
            btnPlaylistOutlet.setTitleColor(#colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), for: .normal)
            lblPlaylist.backgroundColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
            
            btnDownloadOutlet.setTitleColor(.white, for: .normal)
            lblDownload.backgroundColor = #colorLiteral(red: 0.9259513617, green: 0.7214286327, blue: 0.1487246752, alpha: 1)
            isSelectedTab = false
            self.activityIndicator.startAnimating()
            fetchSongFromServer()
            if TonneruMusicPlayer.player?.isPlaying ?? false{
                self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 88))
            }else{
                self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            }
        }
    }
    
    func fetchSongFromServer(){
        Alamofire.request(URL(string: "https://tonnerumusic.com/api/v1/mydownloads")!,
                          method: .post,
                          parameters: [
                            "user_id": UserDefaults.standard.fetchData(forKey: .userId)
                          ] as [String: String])
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    self.fetchOfflineData()
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.result.value as? NSArray ?? NSArray()
                ContentDetailsEntity.deleteAll()
                for responseJ in resposeJSON {
                    let item = responseJ as! NSDictionary
                    let model = SongModel(song_id: item["song_id"] as? String ?? "", song_name: item["song_name"] as? String ?? "", image: item["image"] as? String ?? "", path: item["song_path"] as? String ?? "", filetype: item["filetype"] as? String ?? "", filesize: item["filesize"] as? String ?? "", duration: item["duration"] as? String ?? "", artist_name: item["artist_name"] as? String ?? "", artistImage: item["artist_image"] as? String ?? "", price: "")
                    self.downloadAudio(data: model)
                }
                self.fetchOfflineData()
            }
    }
    
    func downloadAudio(data: SongModel){
        var contentData =  ContentDetailsEntityModel()
        contentData.artistImage = data.artistImage
        contentData.artistName = data.artist_name
        contentData.songName = data.song_name
        contentData.songID = data.song_id
        contentData.songImage = data.image
        contentData.songPath = data.path
        contentData.fileSize = data.filesize
        contentData.fileType = data.filetype
        contentData.songDuration = data.duration.durationString
        TonneruDownloadManager.shared.download(data: contentData)
    }
}

//MARK:- Uitableview Action
extension PlayListViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSelectedTab{
            return 2
        }else{
            return 1
        }
      
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSelectedTab{
      return section == 0 ? 1 : playListData.count
        }else{
            return offlineData.count
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if isSelectedTab{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayListTableViewCell", for: indexPath) as! PlayListTableViewCell
            if indexPath.section == 1{
                cell.playListData = playListData[indexPath.row]
                cell.deleteplayListButton.tag = indexPath.row
                cell.editPlaylistButton.tag = indexPath.row
                cell.deleteplayListButton.addTarget(self, action: #selector(deletePlaylist), for: .touchUpInside)
                cell.editPlaylistButton.addTarget(self, action: #selector(editPlaylist), for: .touchUpInside)
                cell.deleteplayListButton.isHidden = false
                cell.editPlaylistButton.isHidden = false
            }else{
                cell.playListName.text = "Create Playlist"
                // cell.createdByLabel.isHidden = true
                cell.playListImageView.image = UIImage.init(named: "create-button")
                    // UIImage(icon: .FAPlus, size: CGSize(width: 30, height: 30), textColor: .white)
                cell.playListImageView.contentMode = .center
                cell.deleteplayListButton.isHidden = true
                cell.editPlaylistButton.isHidden = true
            }
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadTableViewCell", for: indexPath) as! DownloadTableViewCell
            cell.backgroundColor = .clear
            cell.data = offlineData[indexPath.row]
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(self.deleteAction(sender:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSelectedTab{
            return 75
        }else{
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelectedTab{
        if indexPath.section == 0{
            let destination = CreatePlayListViewViewController(nibName: "CreatePlayListViewViewController", bundle: nil)
            destination.strCreate = "Playlist"
            destination.viewcontroller = self
           self.present(destination, animated: true, completion: nil)
//            self.navigationController?.pushViewController(destination, animated: false)
        }
        else{
            let destination = SongsInPlaylistViewController(nibName: "SongsInPlaylistViewController", bundle: nil)
            destination.plyalist_id = playListData[indexPath.row].id
            destination.playlist_name = playListData[indexPath.row].name
            self.navigationController?.pushViewController(destination, animated: true)
        }
        }else{
            resetPlayer()
            TonneruMusicPlayer.shared.initialize()
            let songData = SongModel(song_id: offlineData[indexPath.row].songID, song_name: offlineData[indexPath.row].songName, image: offlineData[indexPath.row].songImage, path: offlineData[indexPath.row].songPath, filetype: offlineData[indexPath.row].fileType, filesize: offlineData[indexPath.row].fileSize, duration: offlineData[indexPath.row].songDuration, artist_name: offlineData[indexPath.row].artistName, artistImage: offlineData[indexPath.row].artistImage)
            TonneruMusicPlayer.shared.playSong(data: [songData], index: 0)
        }
        
    }
}
