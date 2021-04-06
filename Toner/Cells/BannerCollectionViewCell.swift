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

    @IBOutlet weak var playerView: UIView!
    static var isSetBanner: Bool = false
    var bannerData: BannerModel!{
        didSet{
            if BannerCollectionViewCell.isSetBanner{
                return
            }
            BannerCollectionViewCell.isSetBanner = true
            let videoURL = URL(string: bannerData.bannerURL)
            let asset = AVAsset(url: videoURL!)
            let item = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: item)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = playerView.bounds
            playerLayer.preferredFrameSize()
            self.playerView.layer.addSublayer(playerLayer)
            
            player.play()
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
                player.seek(to: CMTime.zero)
                player.play()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }
    
}
