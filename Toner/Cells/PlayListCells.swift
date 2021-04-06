//
//  PlayListCells.swift
//  CollectionViewShelfLayout
//
//  Created by Muvi on 11/12/17.
//  Copyright © 2017 Pitiphong Phongpattranont. All rights reserved.
//

import UIKit

class PlayListCells: UITableViewCell {

    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var ganre: UILabel!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var images: UIImageView!
    @IBOutlet weak var bottomView: UILabel!
    @IBOutlet weak var lblPlayListCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bottomView.backgroundColor = .white
        self.songName.lineBreakMode = .byTruncatingTail
        self.selectionStyle = .none
        //self.contentView.backgroundColor = ThemeColor.backgroundColor
        self.songName.textColor = .white
        self.songName.font = UIFont.montserratRegular.withSize(15)
        self.ganre.layer.cornerRadius = 5
        self.ganre.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}

