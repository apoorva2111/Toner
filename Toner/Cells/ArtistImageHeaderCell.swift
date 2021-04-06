//
//  ArtistImageHeaderCell.swift
//  Toner
//
//  Created by Users on 14/11/19.
//  Copyright © 2019 Users. All rights reserved.
//

import UIKit
import Kingfisher

class ArtistImageHeaderCell: UITableViewCell {

    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var nuButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var vimeoButton: UIButton!
    @IBOutlet weak var tiktokButton: UIButton!
    @IBOutlet weak var trillerButton: UIButton!
    
    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistTypeLabel: UILabel!
    @IBOutlet weak var playAllButton: UIButton!
    
    @IBOutlet weak var artistImage: UIImageView!
    
    @IBOutlet weak var headerOverlay: UIView!
    @IBOutlet weak var footerOverlay: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let googlePlusImage = UIImage(icon: .FAGooglePlus, size: CGSize(width: 30, height: 30), textColor: .white)
        let nuImage = UIImage(icon: .FAYelp, size: CGSize(width: 30, height: 30),textColor: .white)
        let twitterImage = UIImage(icon: .FATwitter, size: CGSize(width: 30, height: 30), textColor: .white)
        
        let instagramImage = UIImage(icon: .FAInstagram, size: CGSize(width: 30, height: 30), textColor: .white)
        let youtubeImage = UIImage(icon: .FAYoutube, size: CGSize(width: 30, height: 30),textColor: .white)
        let vimeoImage = UIImage(icon: .FAVimeo, size: CGSize(width: 30, height: 30), textColor: .white)
        let tiktokImage = UIImage(icon: .FATencentWeibo, size: CGSize(width: 30, height: 30), textColor: .white)
        let trillerImage = UIImage(icon: .FATencentWeibo, size: CGSize(width: 30, height: 30), textColor: .white)
        
        websiteButton.setImage(googlePlusImage, for: UIControl.State())
        nuButton.setImage(nuImage, for: UIControl.State())
        twitterButton.setImage(twitterImage, for: UIControl.State())
        instagramButton.setImage(instagramImage, for: UIControl.State())
        youtubeButton.setImage(youtubeImage, for: UIControl.State())
        vimeoButton.setImage(vimeoImage, for: UIControl.State())
        tiktokButton.setImage(tiktokImage, for: UIControl.State())
        trillerButton.setImage(trillerImage, for: UIControl.State())
        
        websiteButton.addTarget(self, action: #selector(self.openWebsite(sender:)), for: .touchUpInside)
        nuButton.addTarget(self, action: #selector(self.openWebsite(sender:)), for: .touchUpInside)
        twitterButton.addTarget(self, action: #selector(self.openWebsite(sender:)), for: .touchUpInside)
        instagramButton.addTarget(self, action: #selector(self.openWebsite(sender:)), for: .touchUpInside)
        youtubeButton.addTarget(self, action: #selector(self.openWebsite(sender:)), for: .touchUpInside)
        vimeoButton.addTarget(self, action: #selector(self.openWebsite(sender:)), for: .touchUpInside)
        tiktokButton.addTarget(self, action: #selector(self.openWebsite(sender:)), for: .touchUpInside)
        trillerButton.addTarget(self, action: #selector(self.openWebsite(sender:)), for: .touchUpInside)
        
        artistNameLabel.font = UIFont.montserratMedium.withSize(18)
        artistTypeLabel.font = UIFont.montserratRegular.withSize(13)
        artistNameLabel.textColor = UIColor.white
        artistTypeLabel.textColor = ThemeColor.subHeadingColor
    }
    
    
    func addGradient(view: UIView, colors: [CGColor]){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(artistImageURL: String){
        let imageURL = URL(string: artistImageURL)!
        artistImage.kf.setImage(with: imageURL)
        artistImage.contentMode = .scaleAspectFill
    }
    
    func setData(artistImageURL: URL){
        artistImage.kf.setImage(with: artistImageURL)
        artistImage.contentMode = .scaleAspectFill
    }
    
    
    func setSocialButtons(data: ArtistSocial){
        websiteButton.isHidden      = (data.website == "")
        nuButton.isHidden           = (data.nu == "")
        twitterButton.isHidden      = (data.twitter == "")
        instagramButton.isHidden    = (data.instagram == "")
        youtubeButton.isHidden      = (data.youtube == "")
        vimeoButton.isHidden        = (data.vimeo == "")
        tiktokButton.isHidden       = (data.tiktok == "")
        trillerButton.isHidden      = (data.triller == "")
        
        
        websiteButton.accessibilityValue      = (data.website)
        nuButton.accessibilityValue           = (data.nu)
        twitterButton.accessibilityValue      = (data.twitter)
        instagramButton.accessibilityValue    = (data.instagram)
        youtubeButton.accessibilityValue      = (data.youtube)
        vimeoButton.accessibilityValue        = (data.vimeo)
        tiktokButton.accessibilityValue       = (data.tiktok)
        trillerButton.accessibilityValue      = (data.triller)
        
    }
    
    @objc func openWebsite(sender: UIButton){
        guard let url = URL(string: sender.accessibilityValue ?? "") else{
            return
        }
        
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            self.appD.topViewController()?.navigationController?.tabBarController?.view.makeToast(message: "Invalid URL")
            
        }
    }
}
