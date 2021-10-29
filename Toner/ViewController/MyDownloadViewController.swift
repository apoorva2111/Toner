//
//  MyDownloadViewController.swift
//  Toner
//
//  Created by User on 31/10/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
class MyDownloadViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var activityIndicator: NVActivityIndicatorView!
    
    var offlineData = [ContentDetailsEntityModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeColor.backgroundColor
        self.setNavigationBar(title: "MY DOWNLOADS", isBackButtonRequired: true, isTransparent: false)
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "DownloadTableViewCell", bundle: nil), forCellReuseIdentifier: "DownloadTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        myplans()
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: (TonneruMusicPlayer.player?.isPlaying ?? false) ? 56 : 0))
    }
    
    func myplans(){
        Alamofire.request(URL(string: "https://tonnerumusic.com/api/v1/myplans")!,
                          method: .post,
                          parameters: [
                            "user_id": UserDefaults.standard.fetchData(forKey: .userId)
                          ] as [String: String])
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    self.fetchOfflineData()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                print(resposeJSON)
                
                if(resposeJSON["status"] as? Bool ?? false){
                    self.fetchSongFromServer()
                }else{
                    self.activityIndicator.stopAnimating()
                    let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
                    self.navigationController?.pushViewController(destination, animated: true)
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
//        let currentDownloadData = CurrentDownloadEntity.fetchData()
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
            self.activityIndicator.startAnimating()
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
                    ContentDetailsEntity.delete(songId: songId)
                    self.fetchOfflineData()
                }
                self.tabBarController?.view.makeToast(message: resposeJSON["message"] as! String)
            }
    }

    fileprivate func resetPlayer(){
        TonneruMusicPlayer.shared.currentIndex = -1
        TonneruMusicPlayer.shared.songList.removeAll()
        TonneruMusicPlayer.repeatMode = .off
        TonneruMusicPlayer.shuffleModeOn = false
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 88))
    }
}

extension MyDownloadViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offlineData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadTableViewCell", for: indexPath) as! DownloadTableViewCell
        cell.backgroundColor = .clear
        cell.data = offlineData[indexPath.row]
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(self.deleteAction(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resetPlayer()
        TonneruMusicPlayer.shared.initialize()
        let songData = SongModel(song_id: offlineData[indexPath.row].songID, song_name: offlineData[indexPath.row].songName, image: offlineData[indexPath.row].songImage, path: offlineData[indexPath.row].songPath, filetype: offlineData[indexPath.row].fileType, filesize: offlineData[indexPath.row].fileSize, duration: offlineData[indexPath.row].songDuration, artist_name: offlineData[indexPath.row].artistName, artistImage: offlineData[indexPath.row].artistImage)
        TonneruMusicPlayer.shared.playSong(data: [songData], index: 0)
    }
}
