//
//  CartListCell.swift
//  Toner
//
//  Created by Mona on 19/10/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit

class CartListCell: UITableViewCell {

    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var orderType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productSizeField: APJTextPickerView!
    @IBOutlet weak var noOfProduct: ValueStepper!
    
    var indexPath = 0
    var delegate : CartListCellDelegate?
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.productName.font = UIFont.montserratMedium
        self.price.font = UIFont.montserratMedium
        self.price.textColor = .white
        self.productName.textColor = ThemeColor.subHeadingColor
       
        setUpsizeField()
        
        setUpNumofItem()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CartListCell {
    fileprivate func setUpsizeField() {
        
        self.productSizeField.currentIndexSelected = 0
        self.productSizeField.type = .strings
        self.productSizeField.layer.cornerRadius = 3
        self.productSizeField.layer.borderColor = ThemeColor.subHeadingColor.cgColor
        self.productSizeField.layer.borderWidth = 1.0
        self.productSizeField.clipsToBounds = true
        self.productSizeField.backgroundColor = ThemeColor.backgroundColor
        self.productSizeField.textColor = ThemeColor.subHeadingColor
        self.productSizeField.font = UIFont.montserratMedium
        self.productSizeField.setRightViewFAIcon(icon: .FAAngleDown, textColor: ThemeColor.subHeadingColor)
        self.productSizeField.textAlignment = .center
        self.productSizeField.text = "xxl"
        self.backgroundColor = ThemeColor.backgroundColor
    }
    
    fileprivate func setUpNumofItem() {
        self.noOfProduct.valueLabel.font = .montserratMedium
        self.noOfProduct.tintColor = ThemeColor.subHeadingColor
        self.noOfProduct.minimumValue = 1
        self.noOfProduct.layer.borderWidth = 1.0
        self.noOfProduct.layer.borderColor = ThemeColor.subHeadingColor.cgColor
        self.noOfProduct.layer.cornerRadius = 2
        self.noOfProduct.clipsToBounds = true
        self.noOfProduct.labelTextColor = .gray
//        self.noOfProduct.addTarget(self, action: #selector(self.quantityValueChanged(_:)), for: .valueChanged)
       
    }
    
    @objc func quantityValueChanged(_ sender: ValueStepper){
        print(self.noOfProduct.value)
        print("sender.tag\(sender.tag)")
        delegate?.didSelectStepperValue(value: self.noOfProduct.value, index: sender.tag)
    }

}

public protocol CartListCellDelegate {
    func didSelectStepperValue(value : Double , index : Int)
}
