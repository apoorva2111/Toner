//
//  SearchViewController.swift
//  Toner
//
//  Created by Users on 09/04/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class SearchViewController: UIViewController {

    @IBOutlet weak var searchLabelText: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var chooseGenreLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var activityIndicator: NVActivityIndicatorView!
    var genreData = [TopGenreModel]()
    var collectionViewWidth = 0.0
    var arrFilterArray:[TopGenreModel] = []
    var searching:Bool = false
    var homeData: HomePageDataModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        self.setNeedsStatusBarAppearanceUpdate()
        self.view.backgroundColor = ThemeColor.backgroundColor
        
        self.setNavigationBar(title: "Search", isBackButtonRequired: false)
        self.setNeedsStatusBarAppearanceUpdate()
        
        searchLabelText.text = "SEARCH"
        searchLabelText.textColor = .white
        searchLabelText.font = UIFont.montserratMedium.withSize(30)
        
        chooseGenreLabel.text = "STATIONS"
        chooseGenreLabel.textColor = ThemeColor.headerColor
        chooseGenreLabel.font = UIFont.montserratMedium.withSize(17)
        
        
        searchTextField.placeholder = "🔍 Artist/Stations" //Artists, Songs or Podcasts 
        searchTextField.tintColor = ThemeColor.buttonColor
        searchTextField.textAlignment = .center
        searchTextField.font = UIFont.montserratRegular
        
        collectionViewWidth = (Double(self.collectionView.frame.width * 0.5) - 25.0)
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSize(width: ((collectionViewWidth / 2) - 5), height: 75)
//        layout.estimatedItemSize = CGSize(width: ((collectionViewWidth / 2) - 5), height: 75)
        print("collectionViewWidth:  \(collectionViewWidth)")
        collectionView.dataSource   = self
        collectionView.delegate     = self
        collectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenreCollectionViewCell")
        collectionView.backgroundColor = .clear
        searchTextField.delegate = self
        genreData = self.appD.genreData
        
        //name
        callWebserviceForArtise()
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if (TonneruMusicPlayer.player?.isPlaying ?? false){
         self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        }else{
            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func callWebserviceForArtise()  {
        self.activityIndicator.startAnimating()
        let reuestURL = "https://tonnerumusic.com/api/v1/getallartists"
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
               
                    
                   let allArtist = resposeJSON["allartists"] as? NSArray ?? NSArray()
                    print(allArtist)
                    
                    for data in allArtist{
                        let topgenre = data as? NSDictionary ?? NSDictionary()
                        let genreId = topgenre["id"] as? String ?? ""
                        var genreName = topgenre["username"] as? String ?? ""
                        genreName = genreName.replacingOccurrences(of: "&amp;", with: " & ")
                        let genreIcon = topgenre["image"] as? String ?? ""
                        let genreColor = topgenre["color"] as? String ?? ""
                        
                        let genreData = TopGenreModel(id: genreId, name: genreName, icon: genreIcon, color: genreColor)
                        self.homeData?.topgenre.append(genreData)
                    }
                    
//                    if self.arrMySongList.count>0{
//                        self.arrMySongList.removeAll()
//                    }
//                    allSongs.forEach { (song) in
//                        let currentSong = song as? NSDictionary ?? NSDictionary()
//                        print(currentSong)
//                        var currentSongData = SongModel()
//                        currentSongData.artist_name = currentSong["artist_name"] as? String ?? ""
//                        currentSongData.duration = currentSong["duration"] as? String ?? ""
//                        currentSongData.filesize = currentSong["filesize"] as? String ?? ""
//                        currentSongData.filetype = currentSong["filetype"] as? String ?? ""
//                        currentSongData.image = currentSong["image"] as? String ?? ""
//                        currentSongData.path = currentSong["path"] as? String ?? ""
//                        currentSongData.song_id = currentSong["song_id"] as? String ?? ""
//                        currentSongData.song_name = currentSong["song_name"] as? String ?? ""
//
//                        self.arrMySongList.append(currentSongData)
//                    }
                
          //  self.lbtMySong.reloadData()
        }
    }
}

extension SearchViewController : UITextFieldDelegate{
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{

            let searchText  = textField.text! + string
          //add matching text to arrya
        arrFilterArray = genreData.filter({(($0.name).localizedCaseInsensitiveContains(searchText))})

            if searchText.count == 1{
            searching = false
          }else{
            searching = true
         }
        
        
      self.collectionView.reloadData()

      return true
    }
}
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching{
            return arrFilterArray.count
        }else{
        return genreData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as! GenreCollectionViewCell
        if searching{
            cell.setData(data: arrFilterArray[indexPath.item])

        }else{
        cell.setData(data: genreData[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewWidth, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //arrFilterArray
        let destination = StationListViewController(nibName: "StationListViewController", bundle: nil)
        if searching {
            destination.stationName = arrFilterArray[indexPath.item].name
            destination.stationID = arrFilterArray[indexPath.item].id

        }else{
        destination.stationName = genreData[indexPath.item].name
        destination.stationID = genreData[indexPath.item].id
        }
        self.navigationController?.pushViewController(destination, animated: true)
    }
}
