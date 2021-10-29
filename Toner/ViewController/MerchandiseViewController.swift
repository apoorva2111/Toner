//
//  MerchandiseViewController.swift
//  Toner
//
//  Created by Users on 09/04/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class MerchandiseViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    let cartButton = BadgedButtonItem(with: UIImage(named: "cart"))
    
    var activityIndicator: NVActivityIndicatorView!
    
    var topSalesProducts = [ProductList]()
    var newArrivalProducts = [ProductList]()
    var categoryProducts = [ProductCategory]()
    var printfulProducts = [PrintfulProducts]()
    var printfulProductsData = [ProductCategory]()
    var dummyImageArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(itemsAdded), name: NSNotification.Name(rawValue: "itemCount"), object: nil)
        // Do any additional setup after loading the view.
        self.setNavigationBar(title: "Shopping Cart", isBackButtonRequired: true , isTransparent: false)
        cartButton.badgeTextColor = .black
        cartButton.badgeTintColor = ThemeColor.buttonColor
        cartButton.position = .right
        cartButton.hasBorder = true
        cartButton.borderColor = .red
        cartButton.badgeSize = .medium
        cartButton.badgeAnimation = true
        
        self.navigationItem.rightBarButtonItem = cartButton
        cartButton.tapAction = {
            let destination = CartDetailsViewController(nibName: "CartDetailsViewController", bundle: nil)
            self.navigationController!.pushViewController(destination, animated: true)
        }
        
        activityIndicator = addActivityIndicator()
        self.view.addSubview(activityIndicator)
        
        self.view.backgroundColor = ThemeColor.backgroundColor
        
        self.navigationController?.navigationBar.barTintColor = .black
        self.title = "Shop"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font : UIFont.montserratMedium.withSize(17)
        ]
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "TopSalesTableViewCell", bundle: nil), forCellReuseIdentifier: "TopSalesTableViewCell")
        tableView.register(UINib(nibName: "GenresTableViewCell", bundle: nil), forCellReuseIdentifier: "GenresTableViewCell")
        getProductList()
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
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 88))
        }else{
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        }
    }
    @objc func itemsAdded(){
        self.cartButton.setBadge(with: self.appD.cartListModel.count)
    }
    
    /// This function is used to get the list of products
    fileprivate func getProductList(){
        self.activityIndicator.startAnimating()
        let apiURL = "http://www.tonnerumusic.com/api/v1/shop"
        let urlConvertible = URL(string: apiURL)!
        Alamofire.request(urlConvertible,
                      method: .get,
                      parameters: nil)
            .validate().responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    self.view.makeToast(message: Message.apiError)
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                let resposeJSON = response.value as? NSDictionary ?? NSDictionary()
                self.activityIndicator.stopAnimating()
                
                let topSales = resposeJSON["topsales"] as? NSArray ?? NSArray()
                self.topSalesProducts.removeAll()
                for index in 0..<topSales.count{
                    let currentItem = topSales[index] as? NSDictionary ?? NSDictionary()
                    var currentTopItems = ProductList()
                    currentTopItems.id = currentItem["id"] as? String ?? ""
                    currentTopItems.name = currentItem["name"] as? String ?? ""
                    currentTopItems.description = currentItem["description"] as? String ?? ""
                    currentTopItems.slug = currentItem["slug"] as? String ?? ""
                    currentTopItems.quantity = currentItem["quantity"] as? String ?? ""
                    currentTopItems.image = currentItem["image"] as? String ?? ""
                    currentTopItems.price = currentItem["price"] as? String ?? ""
                    currentTopItems.subtract = currentItem["subtract"] as? String ?? ""
                    currentTopItems.sort_order = currentItem["sort_order"] as? String ?? ""
                    currentTopItems.status = currentItem["status"] as? String ?? ""
                    currentTopItems.viewed = currentItem["viewed"] as? String ?? ""
                    self.topSalesProducts.append(currentTopItems)
                }
                
                let newArrivals = resposeJSON["newarrival"] as? NSArray ?? NSArray()
                self.newArrivalProducts.removeAll()
                for index in 0..<newArrivals.count{
                    let currentItem = topSales[index] as? NSDictionary ?? NSDictionary()
                    var currentTopItems = ProductList()
                    currentTopItems.id = currentItem["id"] as? String ?? ""
                    currentTopItems.name = currentItem["name"] as? String ?? ""
                    currentTopItems.description = currentItem["description"] as? String ?? ""
                    currentTopItems.slug = currentItem["slug"] as? String ?? ""
                    currentTopItems.quantity = currentItem["quantity"] as? String ?? ""
                    currentTopItems.image = currentItem["image"] as? String ?? ""
                    currentTopItems.price = currentItem["price"] as? String ?? ""
                    currentTopItems.subtract = currentItem["subtract"] as? String ?? ""
                    currentTopItems.sort_order = currentItem["sort_order"] as? String ?? ""
                    currentTopItems.status = currentItem["status"] as? String ?? ""
                    currentTopItems.viewed = currentItem["viewed"] as? String ?? ""
                    self.newArrivalProducts.append(currentTopItems)
                }
                
                let categories = resposeJSON["categories"] as? NSArray ?? NSArray()
                self.categoryProducts.removeAll()
                for index in 0..<categories.count{
                    let currentItem = categories[index] as? NSDictionary ?? NSDictionary()
                    var currentTopItems = ProductCategory()
                    currentTopItems.id = currentItem["id"] as? String ?? ""
                    currentTopItems.name = currentItem["name"] as? String ?? ""
                    currentTopItems.slug = currentItem["slug"] as? String ?? ""
                    currentTopItems.image = currentItem["image"] as? String ?? ""
                    self.categoryProducts.append(currentTopItems)
                }
                
                let printfulProducts = resposeJSON["printful_products"] as? NSArray ?? NSArray()
                self.printfulProducts.removeAll()
                for index in 0..<printfulProducts.count{
                    let currentItem = printfulProducts[index] as? NSDictionary ?? NSDictionary()
                    var currentTopItems = PrintfulProducts()
                    currentTopItems.id = currentItem["id"] as? Int64 ?? 0
                    currentTopItems.name = currentItem["name"] as? String ?? ""
                    currentTopItems.external_id = currentItem["external_id"] as? String ?? ""
                    currentTopItems.variants = currentItem["variants"] as? Int ?? 0
                    currentTopItems.synced = currentItem["synced"] as? Int ?? 0
                    currentTopItems.thumbnail_url = currentItem["thumbnail_url"] as? String ?? ""
                    self.printfulProducts.append(currentTopItems)
                }
                self.printfulProductsData = self.printfulProducts.map({ (data) -> ProductCategory in
                    
                    let currentData = ProductCategory(id: "\(data.id)", image: data.thumbnail_url, name: data.name, slug: data.external_id)
                    return currentData
                })
                self.tableView.reloadData()
        }
    }
}

extension MerchandiseViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 2, 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopSalesTableViewCell", for: indexPath) as! TopSalesTableViewCell
            cell.topSalesLabelText = "Top sale".uppercased()
            cell.setData(data: topSalesProducts, vc: self)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopSalesTableViewCell", for: indexPath) as! TopSalesTableViewCell
            cell.topSalesLabelText = "New arrival".uppercased()
            cell.setData(data: newArrivalProducts, vc: self)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenresTableViewCell", for: indexPath) as! GenresTableViewCell
            cell.topArtistLabel.text = "Shop by categories".uppercased()
            cell.topArtistLabel.textColor = .black
            cell.isProduct = true
            cell.productCategories = categoryProducts
            cell.backgroundColor = .white
            cell.viewController = self
            cell.bottomView.backgroundColor = ThemeColor.backgroundColor
            cell.collectionView.tag = 0
            cell.collectionView.reloadData()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenresTableViewCell", for: indexPath) as! GenresTableViewCell
            cell.topArtistLabel.text = "TON'NERU MUSIC SIGNATURE COLLECTION & ACCESSORIES".uppercased()
            cell.topArtistLabel.textColor = .black
            cell.productCategories = printfulProductsData
            cell.isProduct = true
            cell.viewController = self
            cell.backgroundColor = .white
            cell.bottomView.backgroundColor = ThemeColor.backgroundColor
            cell.collectionView.tag = 1
            cell.collectionView.reloadData()
            return cell
        default:
            break;
        }
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0, 1:
            return 290
        case 2:
            return ((tableView.frame.width / 2) * 1.6) * round(0.5 * CGFloat(categoryProducts.count))
        case 3:
            return ((tableView.frame.width / 2) * 1.6) * round(0.5 * CGFloat(printfulProducts.count))
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, data: ProductCategory) {
        if collectionView.tag == 1{
            let destination = CategoryListViewController(nibName: "CategoryListViewController", bundle: nil)
            destination.categoryId = data.id
            destination.categoryName = data.name
            destination.isPrintful = true
            self.navigationController?.pushViewController(destination, animated: true)
        }else{
            let destination = CategoryListViewController(nibName: "CategoryListViewController", bundle: nil)
            destination.categoryId = data.id
            destination.categoryName = data.name
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
}
