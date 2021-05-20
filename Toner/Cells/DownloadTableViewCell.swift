//
//  DownloadTableViewCell.swift
//  Toner
//
//  Created by User on 31/10/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import Kingfisher

class DownloadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var songInfo: UILabel!
    
    
    var data: ContentDetailsEntityModel!{
        didSet{
            songImage.image = UIImage(contentsOfFile: data.songImage)
            artistName.text = data.artistName
            songName.text = data.songName
            songInfo.text = "File Size: \(data.fileSize) | Duration: \(data.songDuration)"
            songImage.backgroundColor = .gray
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backView.backgroundColor = .clear//UIColor.init(hexString: "#000000", alpha: 0.6)
        
        songName.textColor = ThemeColor.headerColor
        artistName.textColor = ThemeColor.subHeadingColor
        songInfo.textColor = ThemeColor.subHeadingColor
        
        songName.font = UIFont.montserratMedium.withSize(16)
        artistName.font = UIFont.montserratLight.withSize(13)
        songInfo.font = UIFont.montserratLight.withSize(13)
        
        let deleteImage = UIImage(icon: .FATrashO, size: CGSize(width: 30, height: 30), textColor: .red)
        deleteButton.setImage(deleteImage, for: UIControl.State())
    }
}
