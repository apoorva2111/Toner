//
//  TopSalesTableViewCell.swift
//  Toner
//
//  Created by Users on 10/04/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit

class TopSalesTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topSalesLabel: UILabel!
    
    var cellSize = CGSize(width: 0, height: 0)
    var parentViewController: UIViewController!
    
    var topSalesLabelText: String = ""{
        didSet{
            topSalesLabel.text = topSalesLabelText
            topSalesLabel.numberOfLines = 2
            topSalesLabel.textColor = ThemeColor.headerColor
        }
    }
    
    var data: [ProductList] = [ProductList]()
    var printfulProducts: [PrintfulProducts] = [PrintfulProducts]()
    var isPrintful = false
    
    var viewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ItemsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemsCollectionViewCell")
        topSalesLabel.textColor = .white
        topSalesLabel.font = UIFont.montserratMedium.withSize(16)
        
    }
    func setData(data: [ProductList], vc: MerchandiseViewController){
        self.data = data
        self.parentViewController = vc
        self.isPrintful = false
        collectionView.reloadData()
    }
    
    func setData(data: [PrintfulProducts], vc: MerchandiseViewController){
        self.printfulProducts = data
        self.parentViewController = vc
        self.isPrintful = true
        collectionView.reloadData()
    }
    
}

extension TopSalesTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isPrintful ? printfulProducts.count : data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isPrintful{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsCollectionViewCell", for: indexPath) as! ItemsCollectionViewCell
            cell.artistImage.kf.setImage(with: URL(string: printfulProducts[indexPath.item].thumbnail_url)!)
            cell.artistImage.backgroundColor = .clear
            cell.artistNameLabel.text = printfulProducts[indexPath.item].name
            cell.artistImage.contentMode = .scaleAspectFill
            cell.artistImage.layer.cornerRadius = 10
            cell.artistImage.clipsToBounds = true
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsCollectionViewCell", for: indexPath) as! ItemsCollectionViewCell
            cell.artistImage.kf.setImage(with: URL(string: data[indexPath.item].image)!)
            cell.artistImage.backgroundColor = .clear
            cell.artistNameLabel.text = data[indexPath.item].name
            cell.artistImage.contentMode = .scaleAspectFill
            cell.artistImage.layer.cornerRadius = 10
            cell.artistImage.clipsToBounds = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 250)//cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
//            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        destination.productName = isPrintful ? self.printfulProducts[indexPath.item].name : self.data[indexPath.item].name
        destination.productID = isPrintful ? String(self.printfulProducts[indexPath.item].id) : self.data[indexPath.item].id
        parentViewController.navigationController?.pushViewController(destination, animated: true)
        
    }
}
