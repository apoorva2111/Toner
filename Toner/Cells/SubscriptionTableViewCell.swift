//
//  SubscriptionTableViewCell.swift
//  Toner
//
//  Created by User on 22/08/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var startDateTimeLabel: UILabel!
    @IBOutlet weak var endDateTimeLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    
    var data: SubscriptionPlanModel!{
        didSet{
            durationLabel.text = data.duration
            frequencyLabel.text = data.frequency
            originalPrice.text = ""
            discountPrice.text = "$" + data.price
            
            if data.package_no_of_songs != ""{
                fromLabel.text = "Package Name:"
                startDateTimeLabel.text = data.name
                toLabel.text = "No. of Songs:"
                endDateTimeLabel.text = data.package_no_of_songs
                
            }else{
                let duration = Int(data.duration) ?? 0
                
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "dd MMM yyyy 'at' hh:mm a"
                startDateTimeLabel.text = dateFormat.string(from: Date())
                if data.frequency == "month"{
                    endDateTimeLabel.text = dateFormat.string(from: Calendar.current.date(byAdding: .month, value: duration, to: Date()) ?? Date())
                }else if data.frequency == "year"{
                     endDateTimeLabel.text = dateFormat.string(from: Calendar.current.date(byAdding: .year, value: duration, to: Date()) ?? Date())
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backView.backgroundColor = ThemeColor.buttonColor
        
        durationLabel.text = ""
        self.fromLabel.text = "From:"
        self.toLabel.text = "To:"
        
        //Format the Labels
        durationLabel.textColor = .black
        //durationLabel.font = UIFont.init(name: "Montserrat-Bold", size: 30)//UIFont.montserratBold.withSize(30)
        
        originalPrice.textColor = .black
        originalPrice.font = UIFont.montserratRegular.withSize(13)
        
        discountPrice.textColor = .black
        //discountPrice.font = UIFont.init(name: "Montserrat-Bold", size: 15)//UIFont.montserratBold.withSize(15)
        
        fromLabel.textColor = .black
        fromLabel.font = UIFont.montserratLight.withSize(13)
        
        toLabel.textColor = .black
        toLabel.font = UIFont.montserratLight.withSize(13)
        
        startDateTimeLabel.textColor = .black
       // startDateTimeLabel.font = UIFont.init(name: "Montserrat-Bold", size: 13)//UIFont.montserratBold.withSize(13)
        
        endDateTimeLabel.textColor = .black
      //  endDateTimeLabel.font = UIFont.init(name: "Montserrat-Bold", size: 13)//UIFont.montserratBold.withSize(13)
    
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
