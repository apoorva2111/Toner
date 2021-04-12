//
//  MySongViewController.swift
//  Toner
//
//  Created by Apoorva Gangrade on 03/04/21.
//  Copyright © 2021 Users. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import MobileCoreServices
import UniformTypeIdentifiers
import AudioPlayerManager
import AVKit
import MediaPlayer
class MySongViewController: UIViewController {
    
    @IBAction func uploadSongAction(_ sender: UIButton) {
       

             
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypeAudio)], in: .import)
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet
            self.present(importMenu, animated: true, completion: nil)
    }
    
    @IBOutlet weak var btnUploadSongOutlet: UIButton!
    @IBOutlet weak var lbtMySong: UITableView!
    var activityIndicator: NVActivityIndicatorView!
    var arrMySongList = [SongModel]()
    
   //https://tonnerumusic.com/api/v1/artistdetails?artist_id=53
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeColor.backgroundColor
        self.setNavigationBar(title: "My Songs", isBackButtonRequired: true, isTransparent: false)
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        lbtMySong.dataSource = self
        lbtMySong.delegate = self
        lbtMySong.register(UINib(nibName: "PlayListTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayListTableViewCell")
        btnUploadSongOutlet.layer.cornerRadius = 5
        btnUploadSongOutlet.layer.masksToBounds = true
        getSongList()
        // Do any additional setup after loading the view.
    }
     func getSongList(){
        self.activityIndicator.startAnimating()
        let reuestURL = "https://tonnerumusic.com/api/v1/artistdetails?artist_id=\(UserDefaults.standard.fetchData(forKey: .userId))"
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
            print(resposeJSON)
               
                if(resposeJSON["status"] as? Bool ?? false){
                    let allSongs = resposeJSON["songs"] as? NSArray ?? NSArray()
                    if self.arrMySongList.count>0{
                        self.arrMySongList.removeAll()
                    }
                    allSongs.forEach { (song) in
                        let currentSong = song as? NSDictionary ?? NSDictionary()
                        print(currentSong)
                        var currentSongData = SongModel()
                        currentSongData.artist_name = currentSong["artist_name"] as? String ?? ""
                        currentSongData.duration = currentSong["duration"] as? String ?? ""
                        currentSongData.filesize = currentSong["filesize"] as? String ?? ""
                        currentSongData.filetype = currentSong["filetype"] as? String ?? ""
                        currentSongData.image = currentSong["image"] as? String ?? ""
                        currentSongData.path = currentSong["path"] as? String ?? ""
                        currentSongData.song_id = currentSong["song_id"] as? String ?? ""
                        currentSongData.song_name = currentSong["song_name"] as? String ?? ""
                        
                        self.arrMySongList.append(currentSongData)
                    }
                }
            self.lbtMySong.reloadData()
        }
    }
    private func resetPlayer(){
        TonneruMusicPlayer.shared.currentIndex = -1
        TonneruMusicPlayer.shared.songList.removeAll()
        TonneruMusicPlayer.repeatMode = .off
        TonneruMusicPlayer.shuffleModeOn = false
        
        self.lbtMySong.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 56))
    }
}

//MARK:- UITableview Delegate Data Source
extension MySongViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMySongList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = lbtMySong.dequeueReusableCell(withIdentifier: "PlayListTableViewCell", for: indexPath) as! PlayListTableViewCell
        cell.backgroundColor = .clear
        cell.playListName.text = self.arrMySongList[indexPath.row].song_name
        let strUrl = self.arrMySongList[indexPath.row].image
        cell.playListImageView.kf.setImage(with: URL(string: strUrl ))
        cell.deleteplayListButton.tag = indexPath.row

        
        cell.deleteplayListButton.tag = indexPath.row
        cell.editPlaylistButton.tag = indexPath.row
        cell.deleteplayListButton.addTarget(self, action: #selector(deletePlaylist), for: .touchUpInside)
        cell.editPlaylistButton.addTarget(self, action: #selector(editPlaylist), for: .touchUpInside)
        cell.deleteplayListButton.isHidden = false
        cell.editPlaylistButton.isHidden = false

        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resetPlayer()
        TonneruMusicPlayer.shared.initialize()
     //   let url = self.arrMySongList[indexPath.row].path
         
        // self.arrMySongList[indexPath.row].path = "https://tonnerumusic.com/storage/uploads/" + url
        let songList = (self.arrMySongList[indexPath.row]) as SongModel
         TonneruMusicPlayer.shared.playSong(data: [songList], index: 0)
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
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
    fileprivate func deletePlaylistApiCAlled(_ index : Int) {
        let bodyParams = [
            "playlist_id": self.arrMySongList[index].song_id
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
            self.getSongList()
            self.activityIndicator.stopAnimating()
            print(resposeJSON)
            
            
        }
    }
    @objc fileprivate func editPlaylist(sender : UIButton){
        let alert = UIAlertController(title: "Edit Playlist Name", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "New playlist name"
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
    
    fileprivate func editPlaylistApiCalled(_ sender: UIButton,_ newPlaylistName : String) {
        let bodyParams = [
            "playlist_id"   : self.arrMySongList[sender.tag].song_id,
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
            self.getSongList()
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
    
}

extension MySongViewController : UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate{
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)

    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
    }
          

//    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
//        documentPicker.delegate = self
//        present(documentPicker, animated: true, completion: nil)
//    }


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
}
