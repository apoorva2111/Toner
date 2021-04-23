//
//  BannerCollectionViewCell.swift
//  Toner
//
//  Created by User on 14/07/20.
//  Copyright © 2020 Users. All rights reserved.
//

import UIKit
import AVKit

class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var playerView: AGVideoPlayerView!
    static var isSetBanner: Bool = false
    var bannerData: BannerModel!{
        didSet{
            if BannerCollectionViewCell.isSetBanner{
                return
            }
            BannerCollectionViewCell.isSetBanner = true
            

         
            let urlStr = bannerData.bannerURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)

            print(urlStr as Any)
            playerView.videoUrl = URL.init(string: urlStr!)
            playerView.shouldAutoplay = true
            playerView.shouldAutoRepeat = true
            playerView.showsCustomControls = true
            
           // playerView.shouldSwitchToFullscreen = true
                        
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }
    
}
