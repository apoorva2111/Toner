//
//  PlayListTableViewCell.swift
//  Toner
//
//  Created by User on 12/09/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import Kingfisher

class PlayListTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var playListImageView: UIImageView!
    @IBOutlet weak var playListName: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    
    @IBOutlet weak var editPlaylistButton: UIButton!
    
    @IBOutlet weak var deleteplayListButton: UIButton!
    
    var playListData: PlayListModel!{
        didSet{
            playListName.text = playListData.name
         //   createdByLabel.text = "by " + playListData.member_name
            if playListData.image == ""{
                playListImageView.image = #imageLiteral(resourceName: "default-poster")
            }else{
                playListImageView.kf.setImage(with: URL(string: playListData.image))

            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        playListName.textColor = .white
        playListName.font = UIFont.montserratMedium.withSize(12)
       // createdByLabel.textColor = ThemeColor.subHeadingColor
      //  createdByLabel.font = UIFont.montserratRegular.withSize(13)
        playListImageView.layer.cornerRadius = 5
        playListImageView.layer.masksToBounds = true
        editPlaylistButton.tintColor = .white
        deleteplayListButton.tintColor = .red
//        editPlaylistButton.setFAIcon(icon: .FAEdit, iconSize: 25.0, forState: .normal)
//                deleteplayListButton.setFAIcon(icon: .FATrash, iconSize: 25.0, forState: .normal)
        
    }
    
}
