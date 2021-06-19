//
//  ArtistCollectionViewCell.swift
//  Toner
//
//  Created by Users on 13/02/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import Kingfisher

class ArtistCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistTypeLabel: UILabel!
    @IBOutlet weak var lblOnline: RCustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        artistNameLabel.textColor = .white
        artistNameLabel.font = UIFont.montserratMedium.withSize(14)
        
        artistTypeLabel.font = UIFont.montserratRegular.withSize(12)
        artistTypeLabel.textColor = ThemeColor.buttonColor
        self.backgroundColor = .clear
        
        lblOnline.layer.cornerRadius = lblOnline.frame.width/2
        lblOnline.layer.masksToBounds = true
    }
    
    func setData(data: ArtistModel){
        print(data)
        artistImage.kf.setImage(with: URL(string: data.image)!)
        artistImage.contentMode = .scaleAspectFill
        artistNameLabel.text = data.firstname + " " + data.lastname
        artistTypeLabel.text = data.type
        if data.is_online == "1"{
            lblOnline.isHidden = false
        }else{
            lblOnline.isHidden = true
        }
    }
    func setData(data: ProductCategory){
        artistImage.kf.setImage(with: URL(string: data.image)!)
        artistImage.contentMode = .scaleAspectFill
        artistNameLabel.text = data.name
        artistNameLabel.textColor = ThemeColor.subHeadingColor
        artistTypeLabel.text = ""
        artistTypeLabel.isHidden = true
    }
    func setData(data: ProductList){
        artistImage.kf.setImage(with: URL(string: data.image)!)
        artistImage.contentMode = .scaleAspectFill
        artistNameLabel.text = data.name
        artistNameLabel.textColor = ThemeColor.subHeadingColor
        artistTypeLabel.text = ""
        artistTypeLabel.isHidden = true
    }
}
