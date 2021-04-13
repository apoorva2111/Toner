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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        self.view.backgroundColor = ThemeColor.backgroundColor
        self.tableView.backgroundColor = ThemeColor.backgroundColor
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
                cell.btnPlaySong.addTarget(self, action: #selector(playSong), for: .touchUpInside)

            }else{
            cell.imgView.kf.setImage(with: URL(string: self.playListData?.image ?? ""))
            cell.imgView.contentMode = .scaleToFill
            cell.btnPlaySong.addTarget(self, action: #selector(playSong), for: .touchUpInside)
            }
            cell.backgroundColor = .clear
return cell
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongInPlayListTVCell", for: indexPath) as! SongInPlayListTVCell
        cell.backgroundColor = .clear
            if isFrom_Album == "Album"{
//                cell.btnDownloadOutlet.tag = indexPath.row
//                cell.btnDownloadOutlet.addTarget(self, action: #selector(downloadSong), for: .touchUpInside)
//
//                cell.btnAddOutlet.tag = indexPath.row
//                cell.btnAddOutlet.addTarget(self, action: #selector(addSong), for: .touchUpInside)
                
                let objAlbum = arrAlbumSong[indexPath.row - 1]
                cell.lblTitle.text = objAlbum.name
                cell.lblDescription.text = ""

            }else{
                let objDict = playListData?.songs[indexPath.row]
                cell.lblTitle.text = objDict?.song_name
                cell.lblDescription.text = objDict?.artist_name
            cell.btnDownloadOutlet.tag = indexPath.row
            cell.btnDownloadOutlet.addTarget(self, action: #selector(downloadSong), for: .touchUpInside)
            
            cell.btnAddOutlet.tag = indexPath.row
            cell.btnAddOutlet.addTarget(self, action: #selector(addSong), for: .touchUpInside)
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
        let url = self.arrAlbumSong[indexPath.row].path ?? ""
        arrAlbumSong[indexPath.row].path = "https://tonnerumusic.com/storage/uploads/" + url

        if isFrom_Album == "Album"{
            let songAlbum = self.arrAlbumSong[indexPath.row]
            var songList = SongModel()
          
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
            let url = self.playListData?.songs[indexPath.row].path ?? ""

            self.playListData?.songs[indexPath.row].path = "https://tonnerumusic.com/storage/uploads/" + url
            let songList = (self.playListData?.songs[indexPath.row])! as SongModel
            TonneruMusicPlayer.shared.playSong(data: [songList], index: 0)

        }
       tableView.reloadData()
    }
}
