//
//  SongInPlayListTVCell.swift
//  Toner
//
//  Created by Apoorva Gangrade on 04/04/21.
//  Copyright © 2021 Users. All rights reserved.
//

import UIKit

class SongInPlayListTVCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAddOutlet: UIButton!
    @IBOutlet weak var btnDownloadOutlet: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var downloadButton: TonneruDownloadButton!
    override func awakeFromNib() {
        super.awakeFromNib()
     
        downloadButton.downloadImageColor = .gray
        downloadButton.progressColor = ThemeColor.buttonColor
        downloadButton.outlineColor = ThemeColor.buttonColor
        downloadButton.progressTextColor = ThemeColor.headerColor
        downloadButton.outlineWidth = 2.5

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
