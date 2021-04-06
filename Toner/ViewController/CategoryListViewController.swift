//
//  StationListViewController.swift
//  Toner
//
//  Created by User on 26/07/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Kingfisher

class CategoryListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var productList = [ProductList]()
    var activityIndicator: NVActivityIndicatorView!
    
    var categoryName: String = ""
    var categoryId: String = ""
    var isPrintful = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        self.view.backgroundColor = ThemeColor.backgroundColor
        
        self.navigationController?.navigationBar.barTintColor = .black
        self.setNavigationBar(title: categoryName, isBackButtonRequired: true)
        self.setNeedsStatusBarAppearanceUpdate()
        
        collectionView.dataSource = self
        collectionView.delegate = self
         collectionView.register(UINib(nibName: "ArtistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArtistCollectionViewCell")
        fetchGenereData(id: categoryId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (TonneruMusicPlayer.player?.isPlaying ?? false){
         self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        }else{
            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func fetchGenereData(id: String){
        self.activityIndicator.startAnimating()
        var reuestURL = "https://tonnerumusic.com/api/v1/categorydetails?category_id=\(id)"
        if isPrintful{
            reuestURL = "https://tonnerumusic.com/api/v1/pcategorydetails?category_id=\(id)"
        }
        
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
                let newProducts = resposeJSON["products"] as? NSArray ?? NSArray()
                for data in newProducts{
                    let newProduct = data as? NSDictionary ?? NSDictionary()
                    let productId = newProduct["product_id"] as? String ?? ""
                    let productThumb = newProduct["thumb"] as? String ?? ""
                    let productName = newProduct["name"] as? String ?? ""
                    let productDescription = newProduct["description"] as? String ?? ""
                    let productPrice = newProduct["price"] as? String ?? ""
    
                    
                    let artistData = ProductList(id: productId, name: productName, description: productDescription, slug: "", quantity: "", image: productThumb, price: productPrice, subtract: "", sort_order: "", status: "", viewed: "")
                    self.productList.append(artistData)
                }
                
                self.collectionView.reloadData()
        }
    }

}


extension CategoryListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCollectionViewCell", for: indexPath) as! ArtistCollectionViewCell
        cell.setData(data: productList[indexPath.item])
        cell.artistImage.layer.cornerRadius = 10
        cell.artistImage.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = 0.0
        if UIDevice.current.userInterfaceIdiom == .pad{
            width = Double((self.view.frame.width - 30) / 4)
        }else{
            width = Double((self.view.frame.width - 20) / 3)
        }
        return CGSize(width: width, height: width * 1.45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        destination.productName = productList[indexPath.item].name
        destination.productID = productList[indexPath.item].id
        destination.isPrintful = isPrintful
        self.navigationController!.pushViewController(destination, animated: true)
    }
}
