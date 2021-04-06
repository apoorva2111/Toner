//
//  MyCommissionTVCell.swift
//  Toner
//
//  Created by Apoorva Gangrade on 30/03/21.
//  Copyright © 2021 Users. All rights reserved.
//

import UIKit

class MyCommissionTVCell: UITableViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDiscription: UILabel!
    @IBOutlet weak var lblTotalCommision: UILabel!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewMain.layer.borderWidth = 1
        self.viewMain.layer.cornerRadius = 4
        self.viewMain.layer.borderColor = #colorLiteral(red: 0.5764705882, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
        self.viewMain.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
