//
//  PlayerViewController.swift
//  SpotifyPlayer
//
//  Created by Maksym Shcheglov on 16/05/2020.
//  Copyright © 2020 Maksym Shcheglov. All rights reserved.
//

import UIKit

class PlayerViewController : UIViewController, UIGestureRecognizerDelegate {
    
    /**
     MiniViewControls
     */
    @IBOutlet weak var tappableView: UIStackView!
    @IBOutlet weak var miniViewPlayPause: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
   
    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var bottomControls: UIView!
    @IBOutlet var miniPlayerView: UIView!
    @IBOutlet var playerView: UIView!
    @IBOutlet var closeButton: UIButton!
    
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var currentProgressLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var backgroundIMageView: UIImageView!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    fileprivate var sliderIsSeeking = false
    
    private lazy var bgLayer: CALayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        bottomControls.layer.insertSublayer(bgLayer, at: 0)
        self.setupFullView()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.artistImage.layer.cornerRadius = 5.0
        self.artistImage.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgLayer.frame = bottomControls.bounds
        print("Hello \(#function)")
    }
    
    fileprivate func setupFullView(){
        let downButtonImage = UIImage(named: "back")
//        (icon: .FAArrowLeft, size: CGSize(width: 40, height: 40), textColor: .white)
        closeButton.setImage(downButtonImage, for: .normal)
        
        progressView.progress = Float(0)
        progressView.progressTintColor = ThemeColor.buttonColor
        
        
        songNameLabel.text = ""
        songNameLabel.textColor = .white
        songNameLabel.font = UIFont.montserratMedium.withSize(15)
        
        artistNameLabel.text = ""
        artistNameLabel.textColor = .white
        artistNameLabel.font = UIFont.montserratLight.withSize(10)
        
        songName.text = ""
        songName.textColor = .white
        songName.font = UIFont.montserratMedium.withSize(20)
        
        artistLabel.text = ""
        artistLabel.textColor = .white
        artistLabel.font = UIFont.montserratMedium.withSize(15)
        
        currentProgressLabel.text = "-:--"
        currentProgressLabel.textColor = .white
        currentProgressLabel.font = UIFont.montserratRegular
        
        timeRemainingLabel.text = "-:--"
        timeRemainingLabel.textColor = .white
        timeRemainingLabel.font = UIFont.montserratRegular
        

        let playImage = UIImage(named: "play-white")
        let pauseImage = UIImage(named: "pause-white")
        playPauseButton.setImage(playImage, for: .normal)
        playPauseButton.setImage(pauseImage, for: .selected)
        playPauseButton.tintColor = .white
        
        
        miniViewPlayPause.setImage(playImage, for: .normal)
        miniViewPlayPause.setImage(pauseImage, for: .selected)
        miniViewPlayPause.imageView?.image = miniViewPlayPause.imageView?.image?.withRenderingMode(.alwaysTemplate)
        miniViewPlayPause.imageView?.tintColor = ThemeColor.buttonColor
//        let singleFinger = UITapGestureRecognizer(target: self, action: #selector(self.playPauseAction(sender:)))
//        miniViewPlayPause.addGestureRecognizer(singleFinger)
        self.view.bringSubviewToFront(miniViewPlayPause)
        
        playPauseButton.addTarget(self, action: #selector(self.playPauseAction(sender:)), for: .touchUpInside)
       miniViewPlayPause.addTarget(self, action: #selector(self.playPauseAction(sender:)), for: .touchUpInside)
        
        let nextButtonImage = UIImage(named: "next")
        nextButton.setImage(nextButtonImage, for: .normal)
        nextButton.addTarget(self, action: #selector(self.nextButtonAction), for: .touchUpInside)
        
        let previousButtonImage = UIImage(named: "prev")
        previousButton.setImage(previousButtonImage, for: .normal)
        previousButton.addTarget(self, action: #selector(self.previousButtonAction), for: .touchUpInside)
  
        let repeatButtonImage = UIImage(named: "repeat")
        repeatButton.setImage(repeatButtonImage, for: .normal)
        
        let shuffleButtonImage = UIImage(named: "shuffle")
        shuffleButton.setImage(shuffleButtonImage, for: .normal)
        shuffleButton.addTarget(self, action: #selector(self.shuffleAction), for: .touchUpInside)
        
        slider.tintColor = ThemeColor.buttonColor
        slider.value = 0
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.addTarget(self, action: #selector(self.sliderValueChanged(sender:)), for: .valueChanged)
        slider.isContinuous = false
        slider.addTarget(self, action: #selector(self.sliderValueChanged(sender:)), for: .touchDown)
        slider.setThumbImage(makeCircleWith(size: CGSize(width: 10, height: 10), backgroundColor: ThemeColor.buttonColor), for: UIControl.State())
        repeatButton.addTarget(self, action: #selector(self.repeatAction), for: .touchUpInside)
    }
    @objc func repeatAction(){
        switch TonneruMusicPlayer.repeatMode {
        case .off:
            if TonneruMusicPlayer.shared.songList.count == 1{
                TonneruMusicPlayer.repeatMode = .once
            }else{
                TonneruMusicPlayer.repeatMode = .on
            }
        case .on:
            TonneruMusicPlayer.repeatMode = .once
        case .once:
            TonneruMusicPlayer.repeatMode = .off
        }
    }
    
    @objc func nextButtonAction(){
        TonneruMusicPlayer.shared.playNextSong()
    }
    
    @objc func previousButtonAction(){
        TonneruMusicPlayer.shared.playPreviousSong()
    }
    
    @objc func shuffleAction(){
        TonneruMusicPlayer.shuffleModeOn = !TonneruMusicPlayer.shuffleModeOn
    }
    
    @objc func sliderValueChanged(sender: UISlider){
        print("CurrentValue: \(sender.value)")
        TonneruMusicPlayer.shared.seek(to: sender.value)
    }
    
    @objc func playPauseAction(sender: UIButton){
        sender.isSelected = !sender.isSelected
        TonneruMusicPlayer.shared.togglePlayPause()
    }
    
    fileprivate func makeCircleWith(size: CGSize = CGSize(width: 10, height: 10), backgroundColor: UIColor = UIColor.white) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
