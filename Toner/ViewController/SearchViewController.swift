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
