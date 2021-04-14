//
//  TopArtistTableViewCell.swift
//  Toner
//
//  Created by Users on 13/02/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit

class TopArtistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topArtistLabel: UILabel!
    @IBOutlet weak var collectionviewHeightConstraint: NSLayoutConstraint!
    
    var artistData = [ArtistModel]()
    var topArtistLabelText = ""
    var viewController: UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ArtistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArtistCollectionViewCell")
        topArtistLabel.textColor = ThemeColor.headerColor
        topArtistLabel.font = UIFont.montserratMedium.withSize(16)
        
        topArtistLabel.text = topArtistLabelText
        
     
    }
    func setartistDatas(arrArtist:[ArtistModel])  {
        print(arrArtist)
        artistData = arrArtist
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()

    }
}

extension TopArtistTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artistData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCollectionViewCell", for: indexPath) as! ArtistCollectionViewCell
        cell.setData(data: artistData[indexPath.item])
        cell.artistImage.layer.cornerRadius = 10
        cell.artistImage.clipsToBounds = true
        topArtistLabel.text = topArtistLabelText.uppercased()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: 130, height: 170)
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (self.collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let homeViewController = viewController as! HomeViewController
        homeViewController.collectionView(collectionView, didSelectItemAt: indexPath, data: artistData[indexPath.item])
    }
    override func layoutSubviews() {

        self.collectionView.collectionViewLayout.invalidateLayout()
   
    }
}
