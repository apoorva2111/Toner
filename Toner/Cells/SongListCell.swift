//
//  SongListCell.swift
//  Toner
//
//  Created by Users on 09/11/19.
//  Copyright © 2019 Users. All rights reserved.
//

//BG Color code - 212121
import UIKit

class SongListCell: UITableViewCell {

    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var downloadButton: TonneruDownloadButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        songName.text = ""
        songName.font = UIFont.montserratRegular
        downloadButton.downloadImageColor = .gray
        downloadButton.progressColor = ThemeColor.buttonColor
        downloadButton.outlineColor = ThemeColor.buttonColor
        downloadButton.progressTextColor = ThemeColor.headerColor
        downloadButton.outlineWidth = 2.5
        artistName.text = ""
        artistName.font = UIFont.montserratLight.withSize(12)
         
        favouriteButton.tintColor = ThemeColor.buttonColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
