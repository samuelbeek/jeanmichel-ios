//
//  PlayerView.swift
//  jeanmichel
//
//  Created by Samuel Beek on 04/07/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit
import Cartography
import CircleProgressView

class PlayerView : UIView {
    
    fileprivate var stationLabel : UILabel!
    fileprivate var progressView : CircleProgressView!
    internal var skipButton, previousButton, playButton : UIButton!
    internal override var backgroundColor: UIColor? {
        didSet {
            progressView.backgroundColor = backgroundColor
        }
    }
    
    init(frame: CGRect, station: Station) {
        
        super.init(frame: frame)
        
        skipButton = UIButton(type: .custom)
        skipButton.setImage(UIImage(named: "buttonSkip"), for: UIControlState())
        addSubview(skipButton)
        
        previousButton = UIButton(type: .custom)
        previousButton.setImage(UIImage(named: "buttonPrevious"), for: UIControlState())
        addSubview(previousButton)

        progressView = CircleProgressView(frame: CGRect(x: 0,y: 0,width: 136,height: 136))
        progressView.trackWidth = 18
        progressView.trackBackgroundColor = .clear 
        progressView.centerImage = UIImage()
        progressView.centerFillColor = .clear 
        progressView.trackBackgroundColor = .clear 
        progressView.trackFillColor = UIColor.black.withAlphaComponent(0.14)
        addSubview(progressView)

        playButton = UIButton(type: .custom)
        playButton.setImage(UIImage(named: "buttonPause"), for: UIControlState())
        addSubview(playButton)
        
        updateProgress(0)
        
        constrain(skipButton, previousButton, playButton) {skip, prev, play in
            
            play.width == 100
            play.height == play.width
            play.centerX == play.superview!.centerX
            play.bottom == play.superview!.bottom - 120
            
            skip.width == 22
            skip.height == 19
            skip.right == skip.superview!.right - 50
            skip.bottom == skip.superview!.bottom - 50
            
            prev.size == skip.size
            prev.bottom == skip.bottom
            prev.left == prev.superview!.left + 50
            
        }
        
    }
    
    func play() {
        playButton.setImage(UIImage(named: "buttonPause"), for: UIControlState())
    }
    
    func pause() {
        playButton.setImage(UIImage(named: "buttonPlay"), for: UIControlState())
    }
    
    func updateProgress(_ progress: Double) {
        self.progressView.setProgress(progress/100, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressView.center = playButton.center
        progressView.backgroundColor = .clear 
        progressView.centerImage = UIImage()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }

}
