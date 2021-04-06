//
//  SettingsTableViewCell.swift
//  Toner
//
//  Created by User on 05/08/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var settingsImage: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!
    
    var data: Setting!{
        didSet{
            self.settingsLabel.text = data.name
            self.settingsImage.image = UIImage(named: data.image)
            self.settingsImage.tintColor = ThemeColor.subHeadingColor
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.settingsView.backgroundColor = .clear
        self.settingsLabel.textColor = ThemeColor.subHeadingColor
        self.settingsLabel.font = .montserratRegular
    }
    
}
