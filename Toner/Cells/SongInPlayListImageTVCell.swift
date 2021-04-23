//
//  SongInPlayListImageTVCell.swift
//  Toner
//
//  Created by Apoorva Gangrade on 04/04/21.
//  Copyright © 2021 Users. All rights reserved.
//

import UIKit

class SongInPlayListImageTVCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnPlayAllSong: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.layer.cornerRadius = 5
        imgView.layer.masksToBounds =  true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
