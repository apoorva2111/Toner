//
//  FollowChatTableViewCell.swift
//  Toner
//
//  Created by User on 11/09/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit

class FollowChatTableViewCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let followImage = UIImage(named: "followers")
        followButton.setImage(followImage, for: UIControl.State())
        followButton.tintColor = #colorLiteral(red: 0.6470588235, green: 0.6431372549, blue: 0.6431372549, alpha: 1)
        followButton.setTitle(" Follow", for: .normal)
        followButton.setTitle(" Following", for: .selected)
        followButton.titleLabel?.font = UIFont.montserratRegular.withSize(15)
        followButton.layer.cornerRadius = 3
        followButton.clipsToBounds = true
        
        let chatImage = UIImage(named: "chat")
        chatButton.setImage(chatImage, for: UIControl.State())
        chatButton.setTitle(" Chat", for: UIControl.State())
        chatButton.titleLabel?.font = UIFont.montserratRegular.withSize(15)
        chatButton.layer.cornerRadius = 3
        chatButton.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
