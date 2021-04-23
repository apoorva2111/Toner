//
//  SongsInPlaylistViewController.swift
//  Toner
//
//  Created by Mona on 27/10/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import AudioPlayerManager
import AVKit
import MediaPlayer

class SongsInPlaylistViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    
    var playListData:PlaylistViewModel?
    var activityIndicator: NVActivityIndicatorView!
    var plyalist_id = ""
    var playlist_name = ""
    var isFrom_Album = ""
    var arrAlbumSong = [Album_Songs]()
    var dict = AlbumSongList(dictionary: [:])
    var checkDownloadStatus = (download_status: false, message: "")


    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        self.view.backgroundColor = ThemeColor.backgroundColor
        self.tableView.backgroundColor = .clear//ThemeColor.backgroundColor
        self.tableView.separatorStyle = .none
        self.setNavigationBar(title: playlist_name, isBackButtonRequired: true , isTransparent: false)
        self.setNeedsStatusBarAppearanceUpdate()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SongInPlayListTVCell", bundle: nil), forCellReuseIdentifier: "SongInPlayListTVCell")
        tableView.register(UINib(nibName: "SongInPlayListImageTVCell", bundle: nil), forCellReuseIdentifier: "SongInPlayListImageTVCell")
        if isFrom_Album == "Album"{
            getAllSongFromAlbum()
        }else{
            getAllSongFromPlaylist()
            
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (TonneruMusicPlayer.player?.isPlaying ?? false){
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 56))

        }else{
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        }
    }
    func getAllSongFromPlaylist(){
        self.activityIndicator.startAnimating()
        
        let bodyParams = [
            "playlist_id": plyalist_id
            ] as [String : String]
        self.activityIndicator.startAnimating()
        Alamofire.request("https://tonnerumusic.com/api/v1/playlistview", method: .post, parameters: bodyParams).validate().responseJSON { (response) in
            
            guard response.result.isSuccess else {
                self.view.makeToast(message: Message.apiError)
                self.activityIndicator.stopAnimating()
                return
            }
            
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            self.activityIndicator.stopAnimating()
            
            print(resposeJSON)
            let playlistData = resposeJSON["playlist"] as? NSDictionary ?? NSDictionary()
            let playlist_id = playlistData["id"] as? String ?? ""
            let playlist_name = playlistData["name"] as? String ?? ""
            let totalsongs = playlistData["totalsongs"] as? Int ?? 0
            let image = playlistData["image"] as? String ?? "0"
            let songsData = playlistData["songs"] as? NSArray ?? NSArray()
            
            var songsList = [SongModel]()
            for index in 0..<songsData.count{
                let newSong = songsData[index] as? NSDictionary ?? NSDictionary()
                let songId =  newSong["id"] as? String ?? ""
                let songName = newSong["name"] as? String ?? ""
                let songimage = newSong["image"] as? String ?? ""
                let songPath = newSong["path"] as? String ?? ""
                let fileType = newSong["filetype"] as? String ?? ""
                let filesize = newSong["filesize"] as? String ?? ""
                let duration = newSong["duration"] as? String ?? ""
                let songData = SongModel(song_id : songId , song_name: songName, image: songimage, path: songPath, filetype: fileType, filesize: filesize, duration: duration, artist_name: "", artistImage: image)
                songsList.append(songData)
            }
            let playlistSongDetails = PlaylistViewModel(playlist_id: playlist_id, playlist_name: playlist_name, totalsongs: totalsongs, image: image, songs: songsList)
            self.playListData = playlistSongDetails
            //show alert for no content
            self.tableView.reloadData()
        }
    }
    
    func getAllSongFromAlbum(){
        self.activityIndicator.startAnimating()
        
        let bodyParams = [
            "album_id": plyalist_id
            ] as [String : String]
        self.activityIndicator.startAnimating()
        Alamofire.request("https://tonnerumusic.com/api/v1/albumDetails", method: .post, parameters: bodyParams).validate().responseJSON { [self] (response) in
            
            guard response.result.isSuccess else {
                self.view.makeToast(message: Message.apiError)
                self.activityIndicator.stopAnimating()
                return
            }
            
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            print(resposeJSON)
            self.activityIndicator.stopAnimating()
            
            print(resposeJSON)
            let albumArray = resposeJSON["songs"] as? NSArray ?? NSArray()
            dict = AlbumSongList(dictionary: resposeJSON)
            if arrAlbumSong.count>0{
                arrAlbumSong.removeAll()
            }
            for objAlbum in albumArray{
                let obj = Album_Songs(dictionary: objAlbum as! NSDictionary)
                arrAlbumSong.append(obj!)
            }
            
            /*
             
             */
            
       self.tableView.reloadData()
        }
    }
    fileprivate func deleteSongApiCAlled(_ index : Int) {
        let bodyParams = [
            "playlist_id": self.plyalist_id,
            "user_id"    : UserDefaults.standard.fetchData(forKey: .userId),
            "song_id"    : self.playListData?.songs[index].song_id ?? ""
            ] as [String : String]
        self.activityIndicator.startAnimating()
        Alamofire.request("https://tonnerumusic.com/api/v1/removesongfromplaylist", method: .post, parameters: bodyParams).validate().responseJSON { (response) in
            
            guard response.result.isSuccess else {
                self.view.makeToast(message: Message.apiError)
                self.activityIndicator.stopAnimating()
                return
            }
            
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
            self.showAlertForPlaylist(message: resposeJSON["message"] as! String)
            self.getAllSongFromPlaylist()
            self.activityIndicator.stopAnimating()
            print(resposeJSON)
            
            
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
    @objc fileprivate func downloadSong(sender : UIButton){
        
//        let alert = UIAlertController(
//            title: "Delete Song!",
//            message: "Are you sure want to delete this song from playlist?",
//            preferredStyle: UIAlertController.Style.alert
//        )
//
//        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
//            self.activityIndicator.startAnimating()
//            self.deleteSongApiCAlled(sender.tag)
//        })
//
//
//        alert.addAction(UIAlertAction(
//            title: "Cancel",
//            style: .cancel
//        ))
//
//        self.present(
//            alert,
//            animated: true,
//            completion: nil
//        )

        
    }
    
    @objc fileprivate func playSong(sender : UIButton){
        resetPlayer()
        TonneruMusicPlayer.shared.initialize()
       // TonneruMusicPlayer.shared.playSong(data: artistDetailsData?.songs ?? [SongModel](), index: 0)
        print(isFrom_Album)
        if isFrom_Album == "Album"{

            var arrSongList = [SongModel]()
            var songList = SongModel()
            for songAlbum in self.arrAlbumSong {
                print(songAlbum.path ?? "")
              //  songList.path = songAlbum.path ?? ""
                let url = songAlbum.path ?? ""

                songList.path = "https://tonnerumusic.com/storage/uploads/" + url

                songList.song_id = songAlbum.id ?? ""
                songList.song_name = songAlbum.name ?? ""
                songList.image = songAlbum.image ?? ""
                songList.filetype = songAlbum.filetype ?? ""
                songList.filesize = songAlbum.filesize ?? ""
                songList.duration = songAlbum.duration ?? ""
                songList.artist_name = dict?.name ?? ""
                songList.artistImage = dict?.image ?? ""
                arrSongList.append(songList)
            }
            print(arrSongList)
            TonneruMusicPlayer.shared.playSong(data: arrSongList, index: 0)

        }else{
            print(self.playListData?.songs ?? [SongModel]())
          
            var arrSongList = [SongModel]()
            var songList = SongModel()
            let arrSong = self.playListData?.songs ?? [SongModel]()
            for songAlbum in arrSong{
                let url = songAlbum.path

                songList.path = "https://tonnerumusic.com/storage/uploads/" + url
                songList.song_id = songAlbum.song_id
                songList.song_name = songAlbum.song_name
                songList.image = songAlbum.image
                songList.filetype = songAlbum.filetype
                songList.filesize = songAlbum.filesize
                songList.duration = songAlbum.duration
                songList.artist_name = songAlbum.artist_name
                songList.artistImage = songAlbum.artistImage
                arrSongList.append(songList)
            }
//
            TonneruMusicPlayer.shared.playSong(data: arrSongList, index: 0)

        }
        

    }

    @objc fileprivate func addSong(sender : UIButton){
        
//        let alert = UIAlertController(
//            title: "Delete Song!",
//            message: "Are you sure want to delete this song from playlist?",
//            preferredStyle: UIAlertController.Style.alert
//        )
//
//        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
//            self.activityIndicator.startAnimating()
//            self.deleteSongApiCAlled(sender.tag)
//        })
//
//
//        alert.addAction(UIAlertAction(
//            title: "Cancel",
//            style: .cancel
//        ))
//
//        self.present(
//            alert,
//            animated: true,
//            completion: nil
//        )

        
    }
    private func resetPlayer(){
        TonneruMusicPlayer.shared.currentIndex = -1
        TonneruMusicPlayer.shared.songList.removeAll()
        TonneruMusicPlayer.repeatMode = .off
        TonneruMusicPlayer.shuffleModeOn = false
        
//        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 56))
//        self.tableView.tableFooterView?.backgroundColor = .green
    }
    
}

extension SongsInPlaylistViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFrom_Album == "Album"{
            return self.arrAlbumSong.count + 1
        }else{
        return self.playListData?.songs.count ?? 0 + 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongInPlayListImageTVCell", for: indexPath) as! SongInPlayListImageTVCell
            if isFrom_Album == "Album"{
                cell.imgView.kf.setImage(with: URL(string: self.dict?.image ?? ""))
                cell.imgView.contentMode = .scaleToFill
                cell.btnPlayAllSong.addTarget(self, action: #selector(playSong), for: .touchUpInside)
                

            }else{
            cell.imgView.kf.setImage(with: URL(string: self.playListData?.image ?? ""))
            cell.imgView.contentMode = .scaleToFill
            cell.btnPlayAllSong.addTarget(self, action: #selector(playSong), for: .touchUpInside)
            }
            cell.backgroundColor = .clear
return cell
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongInPlayListTVCell", for: indexPath) as! SongInPlayListTVCell
        cell.backgroundColor = .clear
            if isFrom_Album == "Album"{
                cell.btnDownloadOutlet.tag = indexPath.row
                cell.btnDownloadOutlet.addTarget(self, action: #selector(downloadSong), for: .touchUpInside)

               // cell.btnAddOutlet.tag = indexPath.row
               // cell.btnAddOutlet.addTarget(self, action: #selector(addSong), for: .touchUpInside)
                cell.downloadButton.delegate = self
               // cell.downloadButton.downloadImage = UIImage(named: "download_list")
                cell.downloadButton.downloadCompleteImage = UIImage(named: "downloadComplete")
                cell.downloadButton.tintColor = ThemeColor.buttonColor
                cell.downloadButton.showProgress = true
                cell.downloadButton.tag = indexPath.row - 1
                var downloadButtonStatus = DownloadButtonStatus.download
                let objAlbum = arrAlbumSong[indexPath.row - 1]
                cell.lblTitle.text = objAlbum.name
                cell.lblDescription.text = ""

                let songID = objAlbum.album_id//arrAlbumSong[indexPath.row].a ?? ""
                if (CurrentDownloadEntity.fetchData(songId: songID!).contentDetails.songID != ""){
                    downloadButtonStatus = .intermediate
                }else if (ContentDetailsEntity.fetchData(songId: songID!).songPath.starts(with: "https")){
                    downloadButtonStatus = .intermediate
                }else if (ContentDetailsEntity.fetchData(songId: songID!).songID != ""){
                    downloadButtonStatus = .downloaded
                }else{
                    downloadButtonStatus = .download
                }
                cell.downloadButton.status = downloadButtonStatus
                
                if TonneruMusicPlayer.shared.currentSong?.song_name ==  objAlbum.name{
                    cell.lblTitle.textColor = ThemeColor.buttonColor
                }else{
                    cell.lblTitle.textColor = .white
                }
               

            }else{
                let objDict = playListData?.songs[indexPath.row]
                cell.lblTitle.text = objDict?.song_name
                cell.lblDescription.text = objDict?.artist_name
            cell.btnDownloadOutlet.tag = indexPath.row
            cell.btnDownloadOutlet.addTarget(self, action: #selector(downloadSong), for: .touchUpInside)
                cell.downloadButton.delegate = self
               // cell.downloadButton.downloadImage = UIImage(named: "download_list")
                cell.downloadButton.downloadCompleteImage = UIImage(named: "downloadComplete")
                cell.downloadButton.tintColor = ThemeColor.buttonColor
                cell.downloadButton.showProgress = true
                cell.downloadButton.tag = indexPath.row
                var downloadButtonStatus = DownloadButtonStatus.download

                let songID = objDict?.song_id//arrAlbumSong[indexPath.row].album_id ?? ""
                if (CurrentDownloadEntity.fetchData(songId: songID!).contentDetails.songID != ""){
                    downloadButtonStatus = .intermediate
                }else if (ContentDetailsEntity.fetchData(songId: songID!).songPath.starts(with: "https")){
                    downloadButtonStatus = .intermediate
                }else if (ContentDetailsEntity.fetchData(songId: songID!).songID != ""){
                    downloadButtonStatus = .downloaded
                }else{
                    downloadButtonStatus = .download
                }
                cell.downloadButton.status = downloadButtonStatus
                
                if TonneruMusicPlayer.shared.currentSong?.song_name ==  objDict?.song_name{
                    cell.lblTitle.textColor = ThemeColor.buttonColor
                }else{
                    cell.lblTitle.textColor = .white
                }
               
          //  cell.btnAddOutlet.tag = indexPath.row
          //  cell.btnAddOutlet.addTarget(self, action: #selector(addSong), for: .touchUpInside)
            }
        return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
           return 300
        }else{
        return 65
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       resetPlayer()
       TonneruMusicPlayer.shared.initialize()

        if isFrom_Album == "Album"{
            let songAlbum = self.arrAlbumSong[indexPath.row]
            var songList = SongModel()
          print(songAlbum.path ?? "")
            songList.path = songAlbum.path ?? ""
            songList.song_id = songAlbum.id ?? ""
            songList.song_name = songAlbum.name ?? ""
            songList.image = songAlbum.image ?? ""
            songList.filetype = songAlbum.filetype ?? ""
            songList.filesize = songAlbum.filesize ?? ""
            songList.duration = songAlbum.duration ?? ""
            songList.artist_name = dict?.name ?? ""
            songList.artistImage = dict?.image ?? ""
            

            TonneruMusicPlayer.shared.playSong(data: [songList], index: 0)

        }else{
//            let url = self.arrAlbumSong[indexPath.row - 1].path ?? ""
//            arrAlbumSong[indexPath.row].path = "https://tonnerumusic.com/storage/uploads/" + url

            let url = self.playListData?.songs[indexPath.row].path ?? ""

            self.playListData?.songs[indexPath.row].path = "https://tonnerumusic.com/storage/uploads/" + url
            let songList = (self.playListData?.songs[indexPath.row])! as SongModel
            TonneruMusicPlayer.shared.playSong(data: [songList], index: 0)

        }
       tableView.reloadData()
    }
}

 

extension SongsInPlaylistViewController: TonneruDownloadManagerDelegate, TonneruDownloadButtonDelegate{
    func tonneruDownloadManager(progress: Float, content: CurrentDownloadEntityModel) {
        if isFrom_Album == "Album"{
            guard let currentIndex = self.playListData?.songs.firstIndex(where: {$0.song_id == content.contentDetails.songID}) else{
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
        }else{
            guard let currentIndex = self.arrAlbumSong.firstIndex(where: {$0.id == content.contentDetails.songID}) else{
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
        
        
    }
    
    func tapAction(state: DownloadButtonStatus, sender: TonneruDownloadButton) {
        print("Download Button State: \(state)")
        
        if isFrom_Album == "Album"{
            self.checkDownloadStatus(song_id: self.arrAlbumSong[sender.tag].album_id ?? "" , download_state : state , index: sender.tag , sender : sender)

        }else{
            self.checkDownloadStatus(song_id: self.playListData?.songs[sender.tag].song_id ?? "" , download_state : state , index: sender.tag , sender : sender)

            
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
        //                        "user_id": "48",
        //                        "song_id": "24"
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
                print(resposeJSON)
                self.activityIndicator.stopAnimating()
                
                status = resposeJSON["download_status"] as? Bool ?? true
                message = resposeJSON["message"] as? String ?? ""
                
                self.checkDownloadStatus = (download_status: status, message: message)
                
                self.downloadActionAccordingToStatus(downloadStatus: self.checkDownloadStatus, state: download_state, index: index, sender : sender, song_id: song_id)
                
                
            }
        
    }
    
    fileprivate func downloadActionAccordingToStatus(downloadStatus : (download_status : Bool, message : String) , state : DownloadButtonStatus , index : Int , sender : TonneruDownloadButton, song_id : String ) {
        if isFrom_Album == "Album"{
            if downloadStatus.download_status {
                switch state {
                case .download:
                    if (playListData?.songs.count ?? 0) > 0{
                        guard let currentSong = playListData?.songs[index] else {return}
                        downloadAudio(data: currentSong, sender: sender)
                    }
                    break
                case .intermediate, .downloading:
                    if (playListData?.songs.count ?? 0) > 0{
                        guard let currentSong = playListData?.songs[index] else {return}
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
                    self.callWebserviceArtistPaymentSong(song_id: song_id)
                    print("add purchase code")
                }
                
                alert.addAction(okAction)
                alert.addAction(purchaseAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            if downloadStatus.download_status {
                switch state {
                case .download:
                    if (arrAlbumSong.count ) > 0{
                        
                      
                        var arrSongList = [SongModel]()
                        var songList = SongModel()
                        for songAlbum in self.arrAlbumSong {

                            songList.path = songAlbum.path ?? ""//"https://tonnerumusic.com/storage/uploads/" + url

                            songList.song_id = songAlbum.id ?? ""
                            songList.song_name = songAlbum.name ?? ""
                            songList.image = songAlbum.image ?? ""
                            songList.filetype = songAlbum.filetype ?? ""
                            songList.filesize = songAlbum.filesize ?? ""
                            songList.duration = songAlbum.duration ?? ""
                            songList.artist_name = dict?.name ?? ""
                            songList.artistImage = dict?.image ?? ""
                            arrSongList.append(songList)
                        }
//                        if arrSongList.count>0{
//                        guard let currentSong = arrSongList[index] else {return}
//                        downloadAudio(data: currentSong, sender: sender)
//                        }
                      
                    }
                    break
                case .intermediate, .downloading:
                    if (arrAlbumSong.count ) > 0{
                        
                        var arrSongList = [SongModel]()
                        var songList = SongModel()
                        for songAlbum in self.arrAlbumSong {
                          //  songList.path = songAlbum.path ?? ""
                          //  let url = songAlbum.path ?? ""

                            songList.path = songAlbum.path ?? ""//"https://tonnerumusic.com/storage/uploads/" + url

                            songList.song_id = songAlbum.id ?? ""
                            songList.song_name = songAlbum.name ?? ""
                            songList.image = songAlbum.image ?? ""
                            songList.filetype = songAlbum.filetype ?? ""
                            songList.filesize = songAlbum.filesize ?? ""
                            songList.duration = songAlbum.duration ?? ""
                            songList.artist_name = dict?.name ?? ""
                            songList.artistImage = dict?.image ?? ""
                            arrSongList.append(songList)
                        }
//                        guard let currentSong = arrSongList[index] else {return}
//                        cancelDownload(data: currentSong, sender: sender)
                    }
                    break
                case .downloaded:
                    break
                }
            }else{
                let alert = UIAlertController(title: "Alert", message: downloadStatus.message, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                let purchaseAction = UIAlertAction(title: "Purchase", style: .default) { (UIAlertAction) in
                    self.callWebserviceArtistPaymentSong(song_id: song_id)
                    print("add purchase code")
                }
                
                alert.addAction(okAction)
                alert.addAction(purchaseAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func callWebserviceArtistPaymentSong(song_id:String) {
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
    
    func downloadAudio(data: SongModel, sender: TonneruDownloadButton){
        let fileSize = ByteCountFormatter.string(fromByteCount: Int64(data.filesize) ?? 0, countStyle: .file)
        let alertMessage = "Do you want to download \(data.song_name)? \n File Size: \(fileSize)"
        let alert = UIAlertController(title: "Alert!", message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            if self.isFrom_Album == "Album"{
                var contentData = ContentDetailsEntityModel()
                contentData.artistImage = self.dict?.image ?? ""
                contentData.artistName = self.dict?.name ?? ""
                contentData.songName = data.song_name
                contentData.songID = data.song_id
                contentData.songImage = data.image
                contentData.songPath = data.path
                contentData.fileSize = data.filesize
                contentData.fileType = "mp3"
                contentData.songDuration = data.duration.durationString
                TonneruDownloadManager.shared.addDownloadTask(data: contentData)
                sender.status = .intermediate

            }else{
                var contentData = ContentDetailsEntityModel()
                contentData.artistImage = self.playListData?.image ?? ""
                contentData.artistName = self.playListData?.playlist_name ?? ""
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

