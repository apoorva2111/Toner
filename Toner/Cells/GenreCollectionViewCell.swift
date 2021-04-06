//
//  GenreCollectionViewCell.swift
//  Toner
//
//  Created by Users on 20/02/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import Kingfisher

class GenreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var genreView: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var genreImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        genreLabel.textColor = .white
        genreLabel.font = .montserratRegular
    }
    
    func setData(data: TopGenreModel){
        genreView.backgroundColor = UIColor(hexString: data.color)
        genreLabel.text = data.name
        genreImage.kf.setImage(with: URL(string: data.icon))
        genreImage.contentMode = .scaleAspectFill
        genreImage.clipsToBounds = true
    }
    
    func setData(data: Station){
        genreView.backgroundColor = UIColor(hexString: data.color)
        genreLabel.text = data.name
        genreImage.kf.setImage(with: URL(string: data.icon))
        genreImage.contentMode = .scaleAspectFill
        genreImage.clipsToBounds = true
    }


}
