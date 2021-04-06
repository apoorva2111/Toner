//
//  CartAmountFooterCell.swift
//  Toner
//
//  Created by Mona on 20/10/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit

class CartAmountFooterCell: UITableViewCell {

    @IBOutlet weak var subtotalText: UILabel!
    @IBOutlet weak var subTotalAmountText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subtotalText.text = "Sub total"
        self.subtotalText.font = UIFont.montserratMedium.withSize(14)
        self.subtotalText.textColor = ThemeColor.subHeadingColor
        self.subTotalAmountText.font = UIFont.montserratMedium.withSize(16)
        self.subTotalAmountText.textColor = ThemeColor.buttonColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
