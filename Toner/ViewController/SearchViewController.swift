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
    var filterGenreData = [TopGenreModel]()
    var collectionViewWidth = 0.0
    var homeData: HomePageDataModel?
    var arrHeader = ["ArtistModel","ArtistModelddjkdfkjkj"]
    var arrArtistList = [ArtistModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    
                }else{
                    let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
                    self.navigationController?.pushViewController(destination, animated: true)
                    
                }
            }
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
        myplans()
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        self.setNeedsStatusBarAppearanceUpdate()
        self.view.backgroundColor = ThemeColor.backgroundColor
        
        self.setNavigationBar(title: "Search", isBackButtonRequired: false)
        self.setNeedsStatusBarAppearanceUpdate()
        
        searchLabelText.text = "SEARCH"
        searchLabelText.textColor = .white
        searchLabelText.font = UIFont.montserratMedium.withSize(30)
        chooseGenreLabel.text = "ARTISTS"
        
        chooseGenreLabel.textColor = ThemeColor.headerColor
        chooseGenreLabel.font = UIFont.montserratMedium.withSize(17)
        
        
        searchTextField.placeholder = "🔍 Artist/Stations"
        searchTextField.tintColor = ThemeColor.buttonColor
        searchTextField.textAlignment = .center
        searchTextField.font = UIFont.montserratRegular
        
        collectionViewWidth = (Double(self.collectionView.frame.width * 0.5) - 25.0)
        print("collectionViewWidth:  \(collectionViewWidth)")
        collectionView.dataSource   = self
        collectionView.delegate     = self
        collectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenreCollectionViewCell")//
        collectionView.register(UINib(nibName: "ArtistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArtistCollectionViewCell")//ArtistCollectionViewCell
        collectionView.register(MyHeaderFooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        collectionView.backgroundColor = .clear
        searchTextField.delegate = self
        genreData = self.appD.genreData
        print(genreData)
        //name
        callWebserviceForArtise()
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
        callWebserviceFOrEndChat()
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
                if self.arrArtistList.count>0{
                    self.arrArtistList.removeAll()
                }
                    for data in allArtist{
                        
                        let topgenre = data as? NSDictionary ?? NSDictionary()
                        let genreIcon = topgenre["image"] as? String ?? ""
                       
                        let email = topgenre["email"] as? String ?? ""
                        let firstname = topgenre["firstname"] as? String ?? ""
                        let lastname = topgenre["lastname"] as? String ?? ""
                        let phone = topgenre["phone"] as? String ?? ""
                        let type = topgenre["type"] as? String ?? ""
                        var username = topgenre["username"] as? String ?? ""
                        username = username.replacingOccurrences(of: "&amp;", with: " & ")
                        let genreId = topgenre["id"] as? String ?? ""
                        let is_online = topgenre["is_online"] as? String
                        
                        let objModel = ArtistModel(id: genreId, firstname: firstname, lastname: lastname, email: email, username: username, phone: phone, image: genreIcon, type: type, is_online: is_online!)
                        self.arrArtistList.append(objModel)
                    }
                if self.arrArtistList.count>0{
                    self.chooseGenreLabel.isHidden = true
                }else{
                    self.chooseGenreLabel.isHidden = false

                }
                self.collectionView.reloadData()
        }
    }
    func webserviceCallSearch(searchText:String){
        self.activityIndicator.startAnimating()
        let param :[String:Any] = ["username":searchText]
        let reuestURL = "https://tonnerumusic.com/api/v1/searchartist"
        let urlConvertible = URL(string: reuestURL)!
        Alamofire.request(urlConvertible,
                          method: .post,
                          parameters: param)
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.tabBarController?.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                self.activityIndicator.stopAnimating()
                print(resposeJSON)
                
                if self.arrArtistList.count>0{
                    self.arrArtistList.removeAll()
                }
                let allArtist = resposeJSON["allartists"] as? NSArray ?? NSArray()
                print(allArtist)
                
                for data in allArtist{
                    
                    let topgenre = data as? NSDictionary ?? NSDictionary()
                    let genreIcon = topgenre["image"] as? String ?? ""
                    
                    let email = topgenre["email"] as? String ?? ""
                    let firstname = topgenre["firstname"] as? String ?? ""
                    let lastname = topgenre["lastname"] as? String ?? ""
                    let phone = topgenre["phone"] as? String ?? ""
                    let type = topgenre["type"] as? String ?? ""
                    var username = topgenre["username"] as? String ?? ""
                    username = username.replacingOccurrences(of: "&amp;", with: " & ")
                    let genreId = topgenre["id"] as? String ?? ""
                    let is_online = topgenre["is_online"] as? String
                    
                    let objModel = ArtistModel(id: genreId, firstname: firstname, lastname: lastname, email: email, username: username, phone: phone, image: genreIcon, type: type, is_online: is_online!)
                   
                 self.arrArtistList.append(objModel)
                }
                
                self.collectionView.reloadData()
            }
    }
    func callWebserviceFOrEndChat(){
//        self.activityIndicator.startAnimating()
        
        let bodyParams = ["user_id": UserDefaults.standard.fetchData(forKey: .userId)] as [String : String]
//        self.activityIndicator.startAnimating()
        Alamofire.request("https://tonnerumusic.com/api/v1/endchatroom", method: .post, parameters: bodyParams).validate().responseJSON { (response) in
            
            guard response.result.isSuccess else {
                self.view.makeToast(message: Message.apiError)
               // self.activityIndicator.stopAnimating()
                return
            }
            
            let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
           // self.activityIndicator.stopAnimating()
            
            print(resposeJSON)
           
            }
           
        }
}

extension SearchViewController : UITextFieldDelegate{
//    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
//        print(textField.text)
//          //add matching text to arrya""
////        if string == ""{
////            callWebserviceForArtise()
////        }else{
//            webserviceCallSearch(searchText:string)
////
////        }
//
//    //  self.collectionView.reloadData()//
//
//      return true
//    }
    func textFieldDidEndEditing(_ textField: UITextField) {

         let filteredArray = genreData.filter { ($0.name.contains(textField.text ?? ""))}
        print(filteredArray)
        filterGenreData = filteredArray
        collectionView.reloadData()
        if textField.text == ""{
            callWebserviceForArtise()
        }else{
            webserviceCallSearch(searchText: textField.text!)
        }
       
       
    }
    
}
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
        return arrArtistList.count
        }else{
            if filterGenreData.count > 0{
                return filterGenreData.count
            }else{
                return genreData.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCollectionViewCell", for: indexPath) as! ArtistCollectionViewCell
        cell.setData(data: arrArtistList[indexPath.item])
        cell.artistImage.layer.cornerRadius = 10
        cell.artistImage.clipsToBounds = true
//        topArtistLabel.text = topArtistLabelText.uppercased()
        return cell
        }else{
            
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as! GenreCollectionViewCell
            if filterGenreData.count > 0{
                cell.setData(data: filterGenreData[indexPath.item])

            }else{
                cell.setData(data: genreData[indexPath.item])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: 130, height: 170)
        if indexPath.section == 0{
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (self.collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
        }else{
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (self.collectionView.frame.size.width - space) / 2.0
            return CGSize(width: size, height: 75)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicListViewController") as! MusicListViewController
        let data = arrArtistList[indexPath.row]
        destination.artistId = data.id
        destination.artistType = data.type
        self.navigationController!.pushViewController(destination, animated: true)
        }else{
            if filterGenreData.count > 0{
                let destination = StationListViewController(nibName: "StationListViewController", bundle: nil)
                let data = filterGenreData[indexPath.row]
                destination.stationName = data.name
                destination.stationID = data.id
                self.navigationController!.pushViewController(destination, animated: true)

            }else{
                let destination = StationListViewController(nibName: "StationListViewController", bundle: nil)
                let data = genreData[indexPath.row]
                destination.stationName = data.name
                destination.stationID = data.id
                self.navigationController!.pushViewController(destination, animated: true)

            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.width, height: 0)

        }else{
            return CGSize(width: collectionView.frame.width, height: 50)

        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
//        switch kind {
//
//        case UICollectionView.elementKindSectionHeader:
//
//            if indexPath.section == 0{
//                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! MyHeaderFooterClass
//                headerView.backgroundColor = UIColor.green//#colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
//                headerView.setHeaderName(name: "ARTISTS")
//                let label = UILabel(frame: headerView.frame)
//              //  label.center = CGPoint(x: 160, y: 285)
//                label.textAlignment = .center
//                label.text = "I'm a test label"
//                headerView.addSubview(label)
////                headerView.lblHeader.text = "ARTISTS"
////
////                headerView.lblHeader.textColor = ThemeColor.headerColor
////                headerView.lblHeader.font = UIFont.montserratMedium.withSize(17)
//           return headerView
//
//            }else{
                let headerView1 = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! MyHeaderFooterClass
                headerView1.backgroundColor = UIColor.clear//#colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
                headerView1.setHeaderName(name: "STATIONS")
            
                let label = UILabel(frame: headerView1.frame)
                label.textAlignment = .left
                label.text = "STATIONS"
        label.textColor = ThemeColor.headerColor
        label.font = UIFont.montserratMedium.withSize(17)

                headerView1.addSubview(label)
                return headerView1

        //   }
            
            
            
//        default:
//            assert(false, "Unexpected element kind")
//        }
    }
}
//{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if searching{
//            return arrFilterArray.count
//
//
//        }else{
//        return arrArtistList.count
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as! GenreCollectionViewCell
//        if searching{
//            cell.setData(data: arrFilterArray[indexPath.item])
//
//        }else{
//        cell.setData(data: genreData[indexPath.item])
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionViewWidth, height: 75)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //arrFilterArray
//        let destination = StationListViewController(nibName: "StationListViewController", bundle: nil)
//        if searching {
//            destination.stationName = arrFilterArray[indexPath.item].name
//            destination.stationID = arrFilterArray[indexPath.item].id
//
//        }else{
//        destination.stationName = genreData[indexPath.item].name
//        destination.stationID = genreData[indexPath.item].id
//        }
//        self.navigationController?.pushViewController(destination, animated: true)
//    }
//}
class MyHeaderFooterClass: UICollectionReusableView {

    @IBOutlet weak var lblHeader: UILabel!
    func setHeaderName(name:String)  {
        print(name)
//        lblHeader.text = name
    }

}
