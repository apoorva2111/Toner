//
//  MyPlanTableViewCell.swift
//  Toner
//
//  Created by Apoorva Gangrade on 20/07/21.
//  Copyright © 2021 Users. All rights reserved.
//

import UIKit

class MyPlanTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPackageName: UILabel!
    @IBOutlet weak var lblTotalSong: UILabel!
    @IBOutlet weak var lblUploadedSong: UILabel!
    @IBOutlet weak var lblReaminingSong: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var data: MyPlanModel!{
        didSet{
            lblPackageName.text = data.package_name
            lblTotalSong.text = String(data.package_no_of_songs)
            lblStatus.text = data.status
            lblUploadedSong.text = String(data.package_no_of_songs)
            lblReaminingSong.text = String(data.package_no_of_songs)

            
        }
    }
    
}
