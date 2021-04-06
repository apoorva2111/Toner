//
//  ProductBannersCollectionViewCell.swift
//  Toner
//
//  Created by User on 15/07/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import Kingfisher

class ProductBannersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productBannerImageView: UIImageView!
    
    var bannerImage: String!{
        didSet{
            self.productBannerImageView.kf.setImage(with: URL(string: bannerImage)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

}
