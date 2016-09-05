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
    
    private var stationLabel : UILabel!
    private var progressView : CircleProgressView!
    internal var skipButton, previousButton, playButton : UIButton!
    internal override var backgroundColor: UIColor? {
        didSet {
            progressView.backgroundColor = backgroundColor
        }
    }
    
    init(frame: CGRect, station: Station) {
        
        super.init(frame: frame)
        
        skipButton = UIButton(type: .Custom)
        skipButton.setImage(UIImage(named: "buttonSkip"), forState: .Normal)
        addSubview(skipButton)
        
        previousButton = UIButton(type: .Custom)
        previousButton.setImage(UIImage(named: "buttonPrevious"), forState: .Normal)
        addSubview(previousButton)

        progressView = CircleProgressView(frame: CGRectMake(0,0,136,136))
        progressView.trackWidth = 18
        progressView.trackBackgroundColor = .clearColor()
        progressView.centerImage = UIImage()
        progressView.centerFillColor = .clearColor()
        progressView.trackBackgroundColor = .clearColor()
        progressView.trackFillColor = UIColor.blackColor().colorWithAlphaComponent(0.14)
        addSubview(progressView)

        playButton = UIButton(type: .Custom)
        playButton.setImage(UIImage(named: "buttonPause"), forState: .Normal)
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
        playButton.setImage(UIImage(named: "buttonPause"), forState: .Normal)
    }
    
    func pause() {
        playButton.setImage(UIImage(named: "buttonPlay"), forState: .Normal)
    }
    
    func updateProgress(progress: Double) {
        self.progressView.setProgress(progress/100, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressView.center = playButton.center
        progressView.backgroundColor = .clearColor()
        progressView.centerImage = UIImage()
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.hidden && subview.alpha > 0 && subview.userInteractionEnabled && subview.pointInside(convertPoint(point, toView: subview), withEvent: event) {
                return true
            }
        }
        return false
    }

}