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
    @IBOutlet weak var viewArtist: RCustomView!
    @IBOutlet weak var viewMember: RCustomView!
    @IBOutlet weak var lblMemberPlanName: UILabel!
    @IBOutlet weak var lblMemberRecurring: UILabel!
    @IBOutlet weak var lblMemberStartDate: UILabel!
    @IBOutlet weak var lblMemberEndDate: UILabel!
    
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
            viewArtist.isHidden = false
            viewMember.isHidden = true
            lblPackageName.text = data.package_name
            lblTotalSong.text = String(data.package_no_of_songs)
            lblStatus.text = data.status
            lblUploadedSong.text = String(data.package_no_of_songs)
            lblReaminingSong.text = String(data.package_no_of_songs)            
        }
    }
    
    var memberdata: MemberPlanModel!{
        didSet{
            viewArtist.isHidden = true
            viewMember.isHidden = false
            lblMemberPlanName.text = memberdata.plan_name
            lblMemberRecurring.text = "$" + memberdata.plan_price.replacingOccurrences(of: "0", with: "", options: NSString.CompareOptions.literal, range: nil)
            lblMemberStartDate.text = memberdata.date_added
            lblMemberEndDate.text = "-"
        }
    }
    
}
