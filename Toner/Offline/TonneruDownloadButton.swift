//
//  TonneruDownloadButton.swift
//  Toner
//
//  Created by User on 24/10/20.
//  Copyright © 2020 Users. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
class TonneruDownloadButton: UIView{
    
    private let shapeLayer = CAShapeLayer()
    private var borderLayer = CAShapeLayer()
    private var tap = UITapGestureRecognizer()
       
    public var delegate: TonneruDownloadButtonDelegate?
    public let percentageLabel      = UILabel()
    public let downloadImageView    = UIImageView()
    
    @IBInspectable
    open var progressColor: UIColor = .white{
        didSet{
            updateDownloadButton()
        }
    }
    
    @IBInspectable
    open var progressTextColor: UIColor = .black{
        didSet{
            updateDownloadButton()
        }
    }
    
    @IBInspectable
    open var outlineColor: UIColor = .white{
        didSet{
            updateDownloadButton()
        }
    }
    
    @IBInspectable
    open var downloadImageColor: UIColor = .white{
        didSet{
            updateDownloadButton()
        }
    }
    
    @IBInspectable
    open var downloadImage: UIImage?{
        didSet{
            updateDownloadButton()
        }
    }
    
    @IBInspectable
    open var downloadingImage: UIImage?{
        didSet{
            updateDownloadButton()
        }
    }
    
    @IBInspectable
    open var downloadCompleteImage: UIImage?{
        didSet{
            updateDownloadButton()
        }
    }
    
    @IBInspectable
    open var outlineWidth: CGFloat = 3{
        didSet{
            updateDownloadButton()
        }
    }
    
    @IBInspectable
    open var showProgress: Bool = false{
        didSet{
            updateDownloadButton()
        }
    }

    
    var progress: Float = 0{
         willSet(newValue)
         {
            if showProgress{
                let currentProgress = Int(newValue * 100)
                percentageLabel.text = "\(currentProgress)%"
                percentageLabel.textColor = progressTextColor
                downloadImageView.image = nil
            }else{
                downloadImageView.image = downloadingImage
            }
                
            startLoading(from: progress, value: newValue)
        }
        
    }
    
    var status: DownloadButtonStatus = .download{
        willSet(newStatus){
            switch newStatus {
            case .download:
                borderLayer.removeFromSuperlayer()
                shapeLayer.removeFromSuperlayer()
                downloadImageView.image = downloadImage
                percentageLabel.text = ""
                break;
            case .intermediate:
                downloadImageView.image = downloadingImage
                percentageLabel.text = ""
                shapeLayer.removeAllAnimations()
                shapeLayer.removeFromSuperlayer()
                repeatLoading()
                break;
            case .downloading:
                self.layer.addSublayer(borderLayer)
                self.layer.addSublayer(shapeLayer)
                break;
            case .downloaded:
                downloadImageView.image = downloadCompleteImage
                percentageLabel.text = ""
                borderLayer.removeFromSuperlayer()
                shapeLayer.removeFromSuperlayer()
                break;
            }
        }
    }
    
    fileprivate func updateDownloadButton(){
        shapeLayer.strokeColor = progressColor.cgColor
        borderLayer.borderColor = outlineColor.cgColor
        shapeLayer.borderColor = outlineColor.cgColor
        
        downloadImageView.tintColor = downloadImageColor
      
        
    }
    
    fileprivate func startLoading(from: Float, value: Float){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = from
        basicAnimation.toValue = value
        basicAnimation.duration = 1.0 //Set the progress Speed
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    fileprivate func repeatLoading(){
        borderLayer.removeFromSuperlayer()
        let beginTime: Double = 0.5
        let strokeStartDuration: Double = 1.2
        let strokeEndDuration: Double = 0.7

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.byValue = Float.pi * 2
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.duration = strokeEndDuration
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.duration = strokeStartDuration
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.beginTime = beginTime

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [rotationAnimation, strokeEndAnimation, strokeStartAnimation]
        groupAnimation.duration = strokeStartDuration + beginTime
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards
      
        let center = CGPoint(x: self.frame.width / 2, y: (self.frame.height / 2))
        let path = UIBezierPath(arcCenter: center, radius: self.frame.width / 2, startAngle: -(.pi / 2), endAngle: .pi + .pi / 2, clockwise: true)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = progressColor.cgColor
        shapeLayer.lineWidth = outlineWidth
        shapeLayer.path = path.cgPath
        
        shapeLayer.frame = self.bounds
        shapeLayer.add(groupAnimation, forKey: "urSoBasic")
        self.layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        let center = CGPoint(x: self.frame.width / 2, y: (self.frame.height / 2))
        let path = UIBezierPath(arcCenter: center, radius: ((self.frame.width / 2) + 2), startAngle: -(.pi / 2), endAngle: .pi + .pi / 2, clockwise: true)
        borderLayer.strokeColor = outlineColor.cgColor
        borderLayer.lineWidth = 2
        borderLayer.path = path.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        
        
        let centerShape = CGPoint(x: self.frame.width / 2, y: (self.frame.height / 2))
        let pathShape = UIBezierPath(arcCenter: centerShape, radius: self.frame.width / 2, startAngle: -(.pi / 2), endAngle: .pi + .pi / 2, clockwise: true)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = progressColor.cgColor
        shapeLayer.lineWidth = outlineWidth
        shapeLayer.path = pathShape.cgPath
        shapeLayer.frame = self.bounds
        
        percentageLabel.removeFromSuperview()
        downloadImageView.removeFromSuperview()
        
        percentageLabel.frame = CGRect(x: 0, y: 0, width: (self.bounds.width), height: (self.bounds.height))
        percentageLabel.center = CGPoint(x: (self.bounds.width / 2), y: (self.bounds.height / 2))
        percentageLabel.textAlignment = .center
//        percentageLabel.adjustsFontSizeToFitWidth = true
        percentageLabel.font = UIFont.montserratRegular.withSize(11)
        self.addSubview(percentageLabel)
        
        downloadImageView.frame = CGRect(x: 0, y: 0, width: (self.bounds.width), height: (self.bounds.height))
        downloadImageView.center = CGPoint(x: (self.bounds.width / 2), y: (self.bounds.height / 2))
        downloadImageView.contentMode = .scaleAspectFit
        self.addSubview(downloadImageView)
        
        self.gestureRecognizers?.removeAll()
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTapEvent))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(handleTapEvent))
        percentageLabel.isUserInteractionEnabled = true
        tapLabel.numberOfTapsRequired = 1
        self.percentageLabel.addGestureRecognizer(tapLabel)
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(handleTapEvent))
        downloadImageView.isUserInteractionEnabled = true
        tapImage.numberOfTapsRequired = 1
        self.downloadImageView.addGestureRecognizer(tapImage)
    }
    
    @objc private func handleTapEvent(sender: UITapGestureRecognizer){
//        delegate?.tapAction(state: status)
        delegate?.tapAction(state: status, sender: (self))
    }
    
}

protocol TonneruDownloadButtonDelegate {
    func tapAction(state: DownloadButtonStatus, sender: TonneruDownloadButton)
}

extension TonneruDownloadButtonDelegate{
    func tapAction(state: DownloadButtonStatus, sender: TonneruDownloadButton){}
}

enum DownloadButtonStatus{
    case download, intermediate, downloading, downloaded
}
