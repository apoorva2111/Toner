//
//  ItemsCollectionViewCell.swift
//  Toner
//
//  Created by Users on 10/04/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit

class ItemsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        artistNameLabel.textColor = .white
        artistNameLabel.font = UIFont.montserratMedium.withSize(14)
        self.backgroundColor = .clear
    }

}
