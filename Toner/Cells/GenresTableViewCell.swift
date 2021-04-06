//
//  GenresTableViewCell.swift
//  Toner
//
//  Created by Users on 20/02/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit

class GenresTableViewCell: UITableViewCell {

    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topArtistLabel: UILabel!
    var viewController: UIViewController?
    var genreData = [TopGenreModel]()
    @IBOutlet weak var bottomView: UIView!
    
    var productCategoryName = "Shop by Categories"
    var isProduct = false
    var productCategories = [ProductCategory]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenreCollectionViewCell")
        collectionView.register(UINib(nibName: "ArtistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArtistCollectionViewCell")
        topArtistLabel.textColor = ThemeColor.headerColor
        topArtistLabel.font = UIFont.montserratMedium.withSize(16)
        topArtistLabel.text = isProduct ? productCategoryName : "STATIONS"
        
        viewAllButton.isHidden = !isProduct
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension GenresTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isProduct ? productCategories.count : genreData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isProduct{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCollectionViewCell", for: indexPath) as! ArtistCollectionViewCell
            cell.setData(data: productCategories[indexPath.item])
            return cell
        }else{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as! GenreCollectionViewCell
            cell.setData(data: genreData[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isProduct{
            return CGSize(width: collectionView.frame.width / 2 - 5, height: ((collectionView.frame.width / 2 - 5) * 1.5))
        }else{
            return CGSize(width: collectionView.frame.width / 2 - 5, height: 75)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isProduct{
            let homeViewController = viewController as? MerchandiseViewController
            homeViewController?.collectionView(collectionView, didSelectItemAt: indexPath, data: productCategories[indexPath.item])
        }else{
            let homeViewController = viewController as? HomeViewController
            homeViewController?.collectionView(collectionView, didSelectItemAt: indexPath, data: genreData[indexPath.item])
        }
        
    }
}
