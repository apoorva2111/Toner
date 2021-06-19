//
//  MusicListViewController.swift
//  Toner
//
//  Created by Users on 09/11/19.
//  Copyright © 2019 Users. All rights reserved.
//

import UIKit
import AudioPlayerManager
import AVKit
import MediaPlayer
import Alamofire
import NVActivityIndicatorView

class MusicListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var activityIndicator: NVActivityIndicatorView!
    var artistDetailsData: ArtistDetailsModel?
    var artistId: String!
    var artistType: String!
    var selectedIndex = -1
    var followButton: UIButton!
    var checkDownloadStatus = (download_status: false, message: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        edgesForExtendedLayout = []
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        self.tableView.register(UINib(nibName: "SongListCell", bundle: nil), forCellReuseIdentifier: "SongListCell")
        self.tableView.register(UINib(nibName: "ArtistImageHeaderCell", bundle: nil), forCellReuseIdentifier: "ArtistImageHeaderCell")
        
        self.tableView.register(UINib(nibName: "FollowChatTableViewCell", bundle: nil), forCellReuseIdentifier: "FollowChatTableViewCell")
        
        self.setNavigationBar(title: "", isBackButtonRequired: true, isTransparent: true)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.backgroundColor = ThemeColor.backgroundColor
        self.setNeedsStatusBarAppearanceUpdate()
        
        TonneruDownloadManager.shared.delegate = self
        getArtistData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (TonneruMusicPlayer.player?.isPlaying ?? false){
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 56))

        }else{
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        }
    }
    
    func getArtistData(){
        self.activityIndicator.startAnimating()
        let apiURL = API_BASE_URL + APIEndPoints.artistdetails + "?artist_id=" + artistId + "&user_id=\(UserDefaults.standard.fetchData(forKey: .userId))"
        print(apiURL)
        let urlConvertible = URL(string: apiURL)!
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
            let results = resposeJSON["status"] as? Int ?? 0
            
            if results == 1{
                let artistData = resposeJSON["artist"] as? NSDictionary ?? NSDictionary()
                let artistName = artistData["name"] as? String ?? ""
                let image = artistData["image"] as? String ?? ""
                let followStatus = artistData["follow"] as? Int ?? 0
                let songsData = resposeJSON["songs"] as? NSArray ?? NSArray()
                
                let socialDict = artistData["social"] as? NSDictionary ?? NSDictionary()
                var socailData = ArtistSocial()
                socailData.website = socialDict["website"] as? String ?? ""
                socailData.nu = socialDict["nu"] as? String ?? ""
                socailData.twitter = socialDict["twitter"] as? String ?? ""
                socailData.instagram = socialDict["instagram"] as? String ?? ""
                socailData.youtube = socialDict["youtube"] as? String ?? ""
                socailData.vimeo = socialDict["vimeo"] as? String ?? ""
                socailData.tiktok = socialDict["tiktok"] as? String ?? ""
                socailData.triller = socialDict["triller"] as? String ?? ""
                
                
                var songsList = [SongModel]()
                for index in 0..<songsData.count{
                    let newSong = songsData[index] as? NSDictionary ?? NSDictionary()
                    let songId =  newSong["song_id"] as? String ?? ""
                    let songName = newSong["song_name"] as? String ?? ""
                    let songimage = newSong["image"] as? String ?? ""
                    let songPath = newSong["path"] as? String ?? ""
                    let fileType = newSong["filetype"] as? String ?? ""
                    let filesize = newSong["filesize"] as? String ?? ""
                    let duration = newSong["duration"] as? String ?? ""
                    let songData = SongModel(song_id : songId , song_name: songName, image: songimage, path: songPath, filetype: fileType, filesize: filesize, duration: duration, artist_name: artistName, artistImage: image)
                    songsList.append(songData)
                }
                let artistDetails = ArtistDetailsModel(artistName: artistName, artistImage: image, followStatus: followStatus, social: socailData, songs: songsList)
                self.artistDetailsData = artistDetails
            }
           
            self.tableView.reloadData()
        }
    }
    
    @objc func playAllButtonAction(){
        resetPlayer()
        TonneruMusicPlayer.shared.initialize()
        TonneruMusicPlayer.shared.playSong(data: artistDetailsData?.songs ?? [SongModel](), index: 0)
        
    }
    
    private func resetPlayer(){
        TonneruMusicPlayer.shared.currentIndex = -1
        TonneruMusicPlayer.shared.songList.removeAll()
        TonneruMusicPlayer.repeatMode = .off
        TonneruMusicPlayer.shuffleModeOn = false
        
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 56))
    }
    
    @objc func addToPlaylist(sender: UIButton){
//        Song Id darakar
         let destination = AddToPlayListViewController(nibName: "AddToPlayListViewController", bundle: nil)
        destination.songId = self.artistDetailsData?.songs[sender.tag].song_id ?? ""
        destination.modalPresentationStyle = .overCurrentContext
        destination.modalTransitionStyle = .crossDissolve
        self.present(destination,animated: true)
    }
    
    @objc func followButtonAction(){
        self.activityIndicator.startAnimating()
        let apiURL = "https://tonnerumusic.com/api/v1/follow"
        let urlConvertible = URL(string: apiURL)!
        Alamofire.request(urlConvertible,
                      method: .post,
                      parameters: [
                        "member_id": UserDefaults.standard.fetchData(forKey: .userId),
                        "artist_id": artistId ?? ""
            ] as [String: String])
        .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                     self.activityIndicator.stopAnimating()
                    return
                }
                
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            self.activityIndicator.stopAnimating()
            
            
            let results = resposeJSON["text"] as? String ?? ""
            
            if results == "Follow"{
                self.tabBarController?.view.makeToast(message: "You have successfully unfollow the artist.")
                self.followButton.isSelected = false
                self.artistDetailsData?.followStatus = 0
            }else{
                self.tabBarController?.view.makeToast(message: "You have successfully follow the artist.")
                self.followButton.isSelected = true
                self.artistDetailsData?.followStatus = 1
            }
            
            NotificationCenter.default.post(name: .UpdateFollowingList, object: nil)
           
            self.tableView.reloadData()
        }
    }
    @objc func chatButtonAction(sender: UIButton){
        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        destination.artistId = artistId
        self.navigationController!.pushViewController(destination, animated: true)

    }
    func callWebserviceArtistPaymentSong(song_id:String, data: SongModel, sender: TonneruDownloadButton) {
        let user:String = UserDefaults.standard.fetchData(forKey: .userId)
        print(user)
        print(song_id)
        self.activityIndicator.startAnimating()
        let apiURL = "https://tonnerumusic.com/api/v1/paymentsong"
        let urlConvertible = URL(string: apiURL)!
        Alamofire.request(urlConvertible,
                      method: .post,
                      parameters: [
                        "song_id": song_id,
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

            if let error = resposeJSON["error"] as? String{
                self.showAlert(message: error)
            }else{
                self.downloadAudio(data: data, sender: sender)

            }
            

//            let results = resposeJSON["text"] as? String ?? ""
//
//            if results == "Follow"{
//                self.tabBarController?.view.makeToast(message: "You have successfully unfollow the artist.")
//                self.followButton.isSelected = false
//                self.artistDetailsData?.followStatus = 0
//            }else{
//                self.tabBarController?.view.makeToast(message: "You have successfully follow the artist.")
//                self.followButton.isSelected = true
//                self.artistDetailsData?.followStatus = 1
//            }
//
//            NotificationCenter.default.post(name: .UpdateFollowingList, object: nil)
//
//            self.tableView.reloadData()
        }
    }
    
    fileprivate func downloadActionAccordingToStatus(downloadStatus : (download_status : Bool, message : String) , state : DownloadButtonStatus , index : Int , sender : TonneruDownloadButton, song_id : String ) {
        
        if downloadStatus.download_status {
            switch state {
            case .download:
                if (artistDetailsData?.songs.count ?? 0) > 0{
                    guard let currentSong = artistDetailsData?.songs[index] else {return}
                    self.callWebserviceArtistPaymentSong(song_id: song_id, data: currentSong, sender: sender)

                }
                break
            case .intermediate, .downloading:
                if (artistDetailsData?.songs.count ?? 0) > 0{
                    guard let currentSong = artistDetailsData?.songs[index] else {return}
                    cancelDownload(data: currentSong, sender: sender)
                }
                break
            case .downloaded:
                break
            }
        }else{
            let alert = UIAlertController(title: "Alert", message: downloadStatus.message, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            let purchaseAction = UIAlertAction(title: "Purchase", style: .default) { (UIAlertAction) in
               //
                let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmSubscriptionViewController") as! ConfirmSubscriptionViewController
                self.navigationController!.pushViewController(destination, animated: true)

            }

            alert.addAction(okAction)
            alert.addAction(purchaseAction)

            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    func checkDownloadStatus(song_id : String , download_state : DownloadButtonStatus , index : Int, sender : TonneruDownloadButton ) {
        self.activityIndicator.startAnimating()
        var status = false
        var message = ""
        let apiURL = "https://tonnerumusic.com/api/v1/downloadsong"
        let urlConvertible = URL(string: apiURL)!
        let params =  [
                        "user_id": UserDefaults.standard.string(forKey: "userId") ?? "",
                        "song_id": song_id
                   ] as [String: String]
//        let params =  [
//                       "user_id": "48",
//                       "song_id": "24"
//                   ] as [String: String]
        Alamofire.request(urlConvertible,
                      method: .post,
                      parameters: params)
        .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                     self.activityIndicator.stopAnimating()
                    return
                }
                
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            self.activityIndicator.stopAnimating()
            
            status = resposeJSON["download_status"] as? Bool ?? true
            message = resposeJSON["message"] as? String ?? ""
            
            self.checkDownloadStatus = (download_status: status, message: message)
            
            self.downloadActionAccordingToStatus(downloadStatus: self.checkDownloadStatus, state: download_state, index: index, sender : sender, song_id: song_id)

            
        }
     
    }
}


extension MusicListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (section == 0) ? 2: (artistDetailsData?.songs.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistImageHeaderCell", for: indexPath) as! ArtistImageHeaderCell
                if let artistURL = URL(string: artistDetailsData?.artistImage ?? ""){
                    cell.setData(artistImageURL: artistURL)
                }
                cell.artistNameLabel.text = artistDetailsData?.artistName
                cell.artistTypeLabel.text = artistType
                cell.playAllButton.addTarget(self, action: #selector(playAllButtonAction), for: .touchUpInside)
                cell.setSocialButtons(data: artistDetailsData?.social ?? ArtistSocial())
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "FollowChatTableViewCell", for: indexPath) as! FollowChatTableViewCell
                self.followButton = cell.followButton
                self.followButton.isSelected = artistDetailsData?.followStatus == 1
                self.followButton.addTarget(self, action: #selector(self.followButtonAction), for: .touchUpInside)
                cell.chatButton.tag = indexPath.row
                cell.chatButton.addTarget(self, action: #selector(self.chatButtonAction), for: .touchUpInside)

                return cell
            }
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell", for: indexPath) as! SongListCell
            cell.artistName.text = artistDetailsData?.songs[indexPath.row].artist_name
            cell.songName.text = artistDetailsData?.songs[indexPath.row].song_name
            cell.downloadButton.delegate = self
            cell.downloadButton.downloadImage = UIImage(named: "download_list")
            cell.downloadButton.downloadCompleteImage = UIImage(named: "downloadComplete")
            cell.downloadButton.tintColor = ThemeColor.buttonColor
            cell.downloadButton.showProgress = true
            cell.downloadButton.tag = indexPath.row
            var downloadButtonStatus = DownloadButtonStatus.download
            let songID = artistDetailsData?.songs[indexPath.row].song_id ?? ""
            if (CurrentDownloadEntity.fetchData(songId: songID).contentDetails.songID != ""){
                downloadButtonStatus = .intermediate
            }else if (ContentDetailsEntity.fetchData(songId: songID).songPath.starts(with: "https")){
                downloadButtonStatus = .intermediate
            }else if (ContentDetailsEntity.fetchData(songId: songID).songID != ""){
                downloadButtonStatus = .downloaded
            }else{
                downloadButtonStatus = .download
            }
            cell.downloadButton.status = downloadButtonStatus
            
            if TonneruMusicPlayer.shared.currentSong?.song_name == artistDetailsData?.songs[indexPath.row].song_name{
                cell.songName.textColor = ThemeColor.buttonColor
            }else{
                cell.songName.textColor = .white
            }
            cell.favouriteButton.tag = indexPath.row
//            cell.favouriteButton.accessibilityValue = artistDetailsData?.songs[indexPath.row].
            cell.favouriteButton.addTarget(self, action: #selector(addToPlaylist(sender:)), for: .touchUpInside)

            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1{
            guard let artistDetailsData = artistDetailsData else {
                return
            }
            resetPlayer()
            TonneruMusicPlayer.shared.initialize()
            TonneruMusicPlayer.shared.playSong(data: [artistDetailsData.songs[indexPath.row]], index: 0)
            tableView.reloadData()
        }
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sc = UIScreen.main.bounds.height * 0.6
        return (indexPath.section == 0 ? (indexPath.row == 0) ? sc : 80 : 75)
    }
}

extension MusicListViewController: TonneruDownloadManagerDelegate, TonneruDownloadButtonDelegate{
    func tonneruDownloadManager(progress: Float, content: CurrentDownloadEntityModel) {
        guard let currentIndex = self.artistDetailsData?.songs.firstIndex(where: {$0.song_id == content.contentDetails.songID}) else{
            return
        }
        let indexPath = IndexPath(row: currentIndex, section: 1)
        if let currentCell = tableView.cellForRow(at: indexPath) as? SongListCell{
            if progress == 1{
                currentCell.downloadButton.status = .downloaded
            }else{
                currentCell.downloadButton.progress = progress
                currentCell.downloadButton.status = .downloading
            }
            
        }
        
    }
    
    func tapAction(state: DownloadButtonStatus, sender: TonneruDownloadButton) {
        print("Download Button State: \(state)")
        
        
        self.checkDownloadStatus(song_id: self.artistDetailsData?.songs[sender.tag].song_id ?? "" , download_state : state , index: sender.tag , sender : sender)
    }
}

extension MusicListViewController{
    func downloadAudio(data: SongModel, sender: TonneruDownloadButton){
        let fileSize = ByteCountFormatter.string(fromByteCount: Int64(data.filesize) ?? 0, countStyle: .file)
        let alertMessage = "Do you want to download \(data.song_name)? \n File Size: \(fileSize)"
        let alert = UIAlertController(title: "Alert!", message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            
            var contentData = ContentDetailsEntityModel()
            contentData.artistImage = self.artistDetailsData?.artistImage ?? ""
            contentData.artistName = self.artistDetailsData?.artistName ?? ""
            contentData.songName = data.song_name
            contentData.songID = data.song_id
            contentData.songImage = data.image
            contentData.songPath = data.path
            contentData.fileSize = data.filesize
            contentData.fileType = "mp3"
            contentData.songDuration = data.duration.durationString
            TonneruDownloadManager.shared.addDownloadTask(data: contentData)
            sender.status = .intermediate
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func cancelDownload(data: SongModel, sender: TonneruDownloadButton){
        
        let alert = UIAlertController(title: "Alert!", message: "Are you sure you want to cancel the download?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            
            if CurrentDownloadEntity.fetchData(songId: data.song_id).contentDetails.songID != ""{
                if CurrentDownloadEntity.fetchData().first?.contentDetails.songID == data.song_id{
                    TonneruDownloadManager.shared.cancelDownload()
                }
                CurrentDownloadEntity.delete(songId: data.song_id, isDownloadCompleted: false)
                sender.status = .download
            }
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
