//
//  AudioPlayerManager.swift
//  Toner
//
//  Created by Users on 11/11/19.
//  Copyright © 2019 Users. All rights reserved.
//

import Foundation
import AVKit
import MediaPlayer
import Kingfisher


class AudioPlayerManager: NSObject{
    
    static var shared = AudioPlayerManager()
    
    private var avPlayer =  AVPlayer()
    fileprivate var avPlayerItem: AVPlayerItem?
    
    public var isPlaying: Bool{
        return (avPlayer.rate > 0.0)
    }
    
    var delegate: AudioPlayerManagerDelegate?
    var periodicObserver : Any?
    
    override init(){
        super.init()
         NotificationCenter.default.addObserver(self, selector: #selector(self.playedToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func updateNowPlayingInfoCenter(artwork: UIImage? = nil, currentTrack: SongModel? = nil, player: AVPlayer) {
        
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentTrack?.songName
        nowPlayingInfo[MPMediaItemPropertyArtist] = currentTrack?.artistName
        
//        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: artwork?.size ?? CGSize.zero, requestHandler: { (size) -> UIImage in
//            return artwork ?? UIImage()
//        })
        
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = TimeInterval(CMTimeGetSeconds((player.currentItem?.currentTime())!))
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = TimeInterval(CMTimeGetSeconds((player.currentItem?.duration)!))
        
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    public func play(currentTrack: SongModel){
        guard let musicURL = URL(string: currentTrack.songURL) else {
            return
        }
        avPlayerItem = AVPlayerItem(url: musicURL)
        avPlayer.replaceCurrentItem(with: avPlayerItem)
        preparePlayer(currentTrack: currentTrack)
        avPlayer.rate = 1.0
        avPlayer.play()
        let imgView = UIImageView()
        imgView.kf.setImage(with: URL(string: currentTrack.songImage))
        updateNowPlayingInfoCenter(artwork: imgView.image, currentTrack: currentTrack, player: avPlayer)
        
        
    }
    
    public func play(url: String){
        guard let musicURL = URL(string: url) else {
            return
        }
        avPlayerItem = AVPlayerItem(url: musicURL)
        avPlayer.replaceCurrentItem(with: avPlayerItem)
        
        avPlayer.rate = 1.0
        avPlayer.play()
    }
    
    public func pause(){
        avPlayer.pause()
    }
    public func play(){
        avPlayer.play()
    }
    
    private func preparePlayer(currentTrack: SongModel){
        periodicObserver = avPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: 1), queue: DispatchQueue.main, using: { [unowned self] time in
            
            let currentTime = Float(CMTimeGetSeconds(self.avPlayer.currentTime()))
            let totalDuration = Float(CMTimeGetSeconds(self.avPlayer.currentItem!.duration))
            
            var progress = 0.0
            if totalDuration > 0.0{
                progress = Double(currentTime / totalDuration)
            }
            
            self.delegate?.updateTracks(currentTrack, progress: CGFloat(progress))
        })
       
    }
    
    @objc func playedToEndTime(){
        delegate?.trackFinishedPlaying()
    }
    
}

protocol AudioPlayerManagerDelegate {
    func trackFinishedPlaying()
    func updateTracks(_ currentTrack: SongModel, progress: CGFloat)
}
