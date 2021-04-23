//
//  HomeViewController.swift
//  Toner
//
//  Created by Users on 13/02/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var activityIndicator: NVActivityIndicatorView!
    var homeData: HomePageDataModel?
    var bannerData = [BannerModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(itemsAdded), name: NSNotification.Name(rawValue: "itemCount"), object: nil)
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
//        self.navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font : UIFont.montserratMedium.withSize(17)
        ]
        self.setNavigationBar(title: "Home", isBackButtonRequired: false)
        self.setNeedsStatusBarAppearanceUpdate()
//        self.title = "Home"
        self.view.backgroundColor = ThemeColor.backgroundColor
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        tableView.register(UINib(nibName: "HomeBannerTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeBannerTableViewCell")
        tableView.register(UINib(nibName: "TopArtistTableViewCell", bundle: nil), forCellReuseIdentifier: "TopArtistTableViewCell")
        tableView.register(UINib(nibName: "GenresTableViewCell", bundle: nil), forCellReuseIdentifier: "GenresTableViewCell")
        getHomeBanner()
        getHomePageData()
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
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 56))
        }else{
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        }
    }
    
    func getHomeBanner(){
        
        self.activityIndicator.startAnimating()
        bannerData = [BannerModel]()
        let reuestURL = "https://www.tonnerumusic.com/api/v1/homebanner"
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
                print(resposeJSON)
                self.activityIndicator.stopAnimating()
            
                if(resposeJSON["status"] as? Bool ?? false){
                    let currentBannerSource = resposeJSON["src"] as? String ?? ""
                    let currentBannerType = resposeJSON["type"] as? String ?? ""
                    let banner = BannerModel(bannerURL: currentBannerSource, bannerType: currentBannerType)
                    self.bannerData.append(banner)
                }
                self.tableView.reloadData()
        }
    }
    @objc func itemsAdded(){
        
    }
    //
    func getHomePageData(){
        
        self.activityIndicator.startAnimating()
        homeData = HomePageDataModel()
        let reuestURL = "https://tonnerumusic.com/api/v1/topnewgen"
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
                print(resposeJSON)
                self.activityIndicator.stopAnimating()
                let topgenres = resposeJSON["topgenre"] as? NSArray ?? NSArray()
                for data in topgenres{
                    let topgenre = data as? NSDictionary ?? NSDictionary()
                    let genreId = topgenre["id"] as? String ?? ""
                    var genreName = topgenre["name"] as? String ?? ""
                    genreName = genreName.replacingOccurrences(of: "&amp;", with: " & ")
                    let genreIcon = topgenre["icon"] as? String ?? ""
                    let genreColor = topgenre["color"] as? String ?? ""
                    
                    let genreData = TopGenreModel(id: genreId, name: genreName, icon: genreIcon, color: genreColor)
                    self.homeData?.topgenre.append(genreData)
                }
                self.appD.genreData = self.homeData?.topgenre ?? [TopGenreModel]()
                let newartists = resposeJSON["newartist"] as? NSArray ?? NSArray()
                for data in newartists{
                    let newartist = data as? NSDictionary ?? NSDictionary()
                    let artistId = newartist["id"] as? String ?? ""
                    let artistFirstName = newartist["firstname"] as? String ?? ""
                    let artistLastName = newartist["lastname"] as? String ?? ""
                    let artistEmail = newartist["email"] as? String ?? ""
                    let artistUserName = newartist["username"] as? String ?? ""
                    let artistPhone = newartist["phone"] as? String ?? ""
                    let artistImage = newartist["image"] as? String ?? ""
                    let artistType = newartist["type"] as? String ?? ""
                    
                    let artistData = ArtistModel(id: artistId, firstname: artistFirstName, lastname: artistLastName, email: artistEmail, username: artistUserName, phone: artistPhone, image: artistImage, type: artistType)
                    self.homeData?.newartist.append(artistData)
                }
                
                let topartists = resposeJSON["topartist"] as? NSArray ?? NSArray()
                for data in topartists{
                    let topartist = data as? NSDictionary ?? NSDictionary()
                    let artistId = topartist["id"] as? String ?? ""
                    let artistFirstName = topartist["firstname"] as? String ?? ""
                    let artistLastName = topartist["lastname"] as? String ?? ""
                    let artistEmail = topartist["email"] as? String ?? ""
                    let artistUserName = topartist["username"] as? String ?? ""
                    let artistPhone = topartist["phone"] as? String ?? ""
                    let artistImage = topartist["image"] as? String ?? ""
                    let artistType = topartist["type"] as? String ?? ""
                    
                    let artistData = ArtistModel(id: artistId, firstname: artistFirstName, lastname: artistLastName, email: artistEmail, username: artistUserName, phone: artistPhone, image: artistImage, type: artistType)
                    self.homeData?.topartist.append(artistData)
                }
                
                self.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeBannerTableViewCell", for: indexPath) as! HomeBannerTableViewCell
            cell.setData(banners: self.bannerData)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopArtistTableViewCell", for: indexPath) as! TopArtistTableViewCell
            cell.artistData = homeData?.topartist ?? [ArtistModel]()
            cell.setartistDatas(arrArtist: homeData?.topartist ?? [ArtistModel]())
            cell.topArtistLabelText = "Top artists"
            
            cell.viewController = self
            cell.layoutIfNeeded()
            let height: CGFloat = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
            cell.collectionviewHeightConstraint.constant = height
            cell.collectionView.reloadData()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopArtistTableViewCell", for: indexPath) as! TopArtistTableViewCell
            cell.artistData = homeData?.newartist ?? [ArtistModel]()
            cell.setartistDatas(arrArtist: homeData?.newartist ?? [ArtistModel]())
            cell.topArtistLabelText = "New artists"
            cell.viewController = self
            cell.layoutIfNeeded()
            let height: CGFloat = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
            cell.collectionviewHeightConstraint.constant = height
            cell.collectionView.reloadData()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenresTableViewCell", for: indexPath) as! GenresTableViewCell
            cell.genreData = homeData?.topgenre ?? [TopGenreModel]()
            cell.viewController = self
            cell.collectionView.reloadData()
            return cell
        default:
            
            let cell = UITableViewCell()
            cell.backgroundColor = .red
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UIScreen.main.bounds.width * (9/16)
        case 1:
            return UITableView.automaticDimension//213
        case 2:
            return UITableView.automaticDimension//213
        case 3:
            return ((CGFloat(((homeData?.topgenre.count ?? 0) + 1) * 85) * CGFloat(0.5) ) + CGFloat(50.0))
        default:
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, data: ArtistModel) {
        
        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicListViewController") as! MusicListViewController
        destination.artistId = data.id
        destination.artistType = data.type
        self.navigationController!.pushViewController(destination, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, data: TopGenreModel) {
        
        let destination = StationListViewController(nibName: "StationListViewController", bundle: nil)
        destination.stationName = data.name
        destination.stationID = data.id
        self.navigationController!.pushViewController(destination, animated: true)
    }

}
