//
//  TonneruMusicPlayer.swift
//  Toner
//
//  Created by Users on 10/11/19.
//  Copyright © 2019 Users. All rights reserved.
//

import Foundation
import UIKit
import AudioPlayerManager
import MediaPlayer
import Alamofire

class TonneruMusicPlayer: NSObject{
    
    private override init(){}
    static var shared = TonneruMusicPlayer()
    
    public var currentSong: SongModel!
    public var currentSongInfo: SongInfo!
    
    public var currentIndex = -1
    public var songList = [SongModel]()
    
    public var delegate: TonneruMusicPlayerDelegate?
    public static var player: AVPlayer!
    fileprivate var playerItem: AVPlayerItem!
    fileprivate var timeObserver: Any!
    public static var repeatMode: RepeatMode = .off
    public static var shuffleModeOn: Bool = false
    
    fileprivate var artworkImage: UIImage!
    public var isMiniViewActive: Bool = false
    
    public func initialize(){
        setupMediaPlayerNotificationView()
        AudioPlayerManager.shared.setup()
        AudioPlayerManager.shared.playingTimeRefreshRate = 1.0
        TonneruMusicPlayer.player = AVPlayer()
        currentSongInfo = SongInfo()
        currentSong = SongModel()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            guard let self = self else { return }
            
            if (TonneruMusicPlayer.player.currentProgress() == 1.0){
                self.playBackEnd()
            }
        }

        timeObserver = TonneruMusicPlayer.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main, using: {[weak self] (time) in
            
            guard let self = self else { return }
            self.updateButtonStates()
            self.updateSongInformation()
        })
        
        
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.artworkImage = UIImage(data: data)
            }
        }
    }
            
    public func playSong(data: SongModel){
        self.playAudio(url: data.path)
        if data.image.starts(with: "http"){
            if let url = URL(string: data.image){
                downloadImage(from: url)
            }
        }else{
            self.artworkImage = UIImage(contentsOfFile: data.image)
        }
    }
    
    public func playSong(data: [SongModel], index: Int){
        self.songList = data
        self.currentIndex = index
        if (self.currentIndex >= 0 && self.currentIndex < self.songList.count){
            self.currentSong = self.songList[self.currentIndex]
            self.playSong(data:  self.currentSong)
        }
    }
    fileprivate func playAudio(url: String){
        if url.starts(with: "http"){
            guard let playerURL = URL(string: url) else {print("Invalid URL"); return}
            self.playerItem = AVPlayerItem(url: playerURL)
        }else{
            self.playerItem = AVPlayerItem(url: URL(fileURLWithPath: url))
        }
        
        TonneruMusicPlayer.player.replaceCurrentItem(with: playerItem)
        TonneruMusicPlayer.player.automaticallyWaitsToMinimizeStalling = false
        TonneruMusicPlayer.player.playImmediately(atRate: 1.0)
        if !isMiniViewActive{
            NotificationCenter.default.post(name: Notification.Name("showMiniView"), object: nil)
            isMiniViewActive = true
        }else{
            isMiniViewActive = false
        }
        
    }
    
    fileprivate func updateButtonStates() {
        if songList.count <= 1{
            TonneruMusicPlayer.shuffleModeOn = false
        }
        delegate?.tonneruMusicPlayer(player: TonneruMusicPlayer.player, events: .updateButtonStates)
    }

    fileprivate func updateSongInformation() {
        if (self.currentIndex >= 0 && self.currentIndex < self.songList.count){
            self.currentSong = self.songList[self.currentIndex]
        }
        self.updatePlaybackTime()
    }
    
    fileprivate func playBackEnd() {
        TonneruMusicPlayer.player.pause()
        delegate?.tonneruMusicPlayer(player: TonneruMusicPlayer.player, events: .playBackEnded)
        switch TonneruMusicPlayer.repeatMode {
        case .off:
            self.playNextSong()
        case .on:
            if self.currentIndex == self.songList.count - 1{
                self.currentIndex = 0
                self.playSong(data: self.songList, index: self.currentIndex)
            }else{
                self.playNextSong()
            }
        case .once:
            TonneruMusicPlayer.player.seek(to: .zero)
            TonneruMusicPlayer.player.automaticallyWaitsToMinimizeStalling = false
            TonneruMusicPlayer.player.playImmediately(atRate: 1.0)
        }
    }
    
    public func playNextSong(){
        if self.currentIndex < self.songList.count - 1{
            self.currentIndex = TonneruMusicPlayer.shuffleModeOn ? shuffedIndex() : ( self.currentIndex + 1)
            self.playSong(data: self.songList, index: self.currentIndex)
        }
    }
    
    public func playPreviousSong(){
        if self.currentIndex > 0{
            self.currentIndex = TonneruMusicPlayer.shuffleModeOn ? shuffedIndex() : ( self.currentIndex - 1)
            self.playSong(data: self.songList, index: self.currentIndex)
        }
    }
    
    fileprivate func shuffedIndex() -> Int{
        var songRange = [Int](0 ... self.songList.count - 1)
        songRange.remove(at: self.currentIndex)
        return Int(arc4random_uniform(UInt32(songRange.count)))
    }

    fileprivate func updatePlaybackTime() {
        let track = TonneruMusicPlayer.player
        currentSongInfo.currentTime = track?.displayablePlaybackTimeString() ?? "-:-"
        currentSongInfo.totalTime = track?.displayableDurationString() ?? "-:-"
        currentSongInfo.timeRemaining = "-" + (track?.displayableTimeLeftString() ?? "-:-")
        currentSongInfo.currentProgress = track?.currentProgress() ?? Float(0)
        delegate?.tonneruMusicPlayer(player: TonneruMusicPlayer.player, song: self.currentSong, songInfo: self.currentSongInfo)
        
        setupNotificationView(song: self.currentSong, info: self.currentSongInfo)
    }
    
    public func togglePlayPause(){
        if TonneruMusicPlayer.player.isPlaying{
            TonneruMusicPlayer.player.pause()
//            NotificationCenter.default.post(name: Notification.Name("hideMiniView"), object: nil)
        }else{
            TonneruMusicPlayer.player.automaticallyWaitsToMinimizeStalling = false
            TonneruMusicPlayer.player.playImmediately(atRate: 1.0)
//            NotificationCenter.default.post(name: Notification.Name("showMiniView"), object: nil)
        }
    }
    
    public func seek(to progressValue: Float){
        let fullTime = TonneruMusicPlayer.player.currentItem?.duration.seconds ?? 0
        let seekTime = fullTime * Double(progressValue)
        TonneruMusicPlayer.player.seek(to: CMTime(seconds: Double(seekTime), preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }

    func setupMediaPlayerNotificationView(){
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.togglePlayPauseCommand.addTarget { [unowned self](event) -> MPRemoteCommandHandlerStatus in
            self.togglePlayPause()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { [unowned self](event) -> MPRemoteCommandHandlerStatus in
            self.playNextSong()
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self](event) -> MPRemoteCommandHandlerStatus in
            self.playPreviousSong()
            return .success
        }
    }
    
    func setupNotificationView(song: SongModel, info: SongInfo){
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = song.song_name
        nowPlayingInfo[MPMediaItemPropertyArtist] = song.artist_name
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = TonneruMusicPlayer.player.currentItem?.duration.seconds
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = (TonneruMusicPlayer.player.currentTime().seconds)
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = TonneruMusicPlayer.player.isPlaying ? 1.0 : 0.0
        if self.artworkImage != nil{
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: self.artworkImage.size) { size in
                           return self.artworkImage
                   }
        }
       
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = ((self.songList.count > 0) && (self.currentIndex >= 0) && (self.currentIndex < (self.songList.count - 1)))
         MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = ((self.songList.count > 0) && (self.currentIndex > 0))
    }
    
    
}

protocol TonneruMusicPlayerDelegate {
    func tonneruMusicPlayer(player: AVPlayer, events: TonneruMusicPlayerEvents)
    func tonneruMusicPlayer(player: AVPlayer, song: SongModel, songInfo: SongInfo)
}
public enum TonneruMusicPlayerEvents{
    case playBackEnded
    case songChanged
    case songFinished
    case willNextActionTrigger
    case didNextActionTrigger
    case willPreviousActionTrigger
    case didPreviousActionTrigger
    case updateButtonStates
}

struct SongInfo {
    var currentTime: String = "-:--"
    var totalTime: String = "-:--"
    var timeRemaining: String = "-:--"
    var currentProgress: Float = 0.0
}

//typealias AVPlayer = AudioPlayerManager
extension AVPlayer{
    var isPlaying: Bool{
        return rate > 0
    }
    func displayablePlaybackTimeString()->String?{
        if !self.currentTime().seconds.isNaN{
            return self.currentTime().positionalTime
        }
        return nil
    }
        
    func displayableDurationString()->String?{
        if !(self.currentItem?.duration.seconds.isNaN ?? true){
            return self.currentItem?.duration.positionalTime
        }
        return nil
    }
    
    func displayableTimeLeftString()->String?{
        let remainingSeconds = ((self.currentItem?.duration.seconds ?? 0) - self.currentTime().seconds)
        return CMTime(seconds: remainingSeconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC)).positionalTime
    }
    
    func currentProgress() -> Float?{
        guard let currentTime = self.currentItem?.currentTime().roundedSeconds else { return 0.0 }
        guard let totalTime = self.currentItem?.duration.roundedSeconds else { return 0.1 }
        let progress = Float(currentTime / totalTime)
        return progress
    }
}

extension CMTime {
    var roundedSeconds: TimeInterval {
        return seconds.rounded()
    }
    var hours:  Int { return Int(roundedSeconds / 3600) }
    var minute: Int { return Int(roundedSeconds.truncatingRemainder(dividingBy: 3600) / 60) }
    var second: Int { return Int(roundedSeconds.truncatingRemainder(dividingBy: 60)) }
    var positionalTime: String {
        return hours > 0 ?
            String(format: "%d:%02d:%02d",
                   hours, minute, second) :
            String(format: "%02d:%02d",
                   minute, second)
    }
}

enum RepeatMode{
    case off
    case on
    case once
}
