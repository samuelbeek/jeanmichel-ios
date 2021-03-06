//
//  PlayerView.swift
//  jeanmichel
//
//  Created by Samuel Beek on 04/07/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit
import Cartography
import RPCircularProgress
import KDEAudioPlayer

class PlayerView : UIView {
    
    fileprivate var stationLabel : UILabel!
    fileprivate var progressView : RPCircularProgress!
    internal var skipButton, previousButton, playButton : UIButton!
    internal override var backgroundColor: UIColor? {
        didSet {
            progressView.backgroundColor = backgroundColor
        }
    }
    
    // MARK: Lifecycle
    
    init(frame: CGRect, station: Station) {
        
        super.init(frame: frame)
        
        skipButton = UIButton(type: .custom)
        skipButton.setImage(UIImage(named: "buttonSkip"), for: UIControlState())
        addSubview(skipButton)
        
        previousButton = UIButton(type: .custom)
        previousButton.setImage(UIImage(named: "buttonPrevious"), for: UIControlState())
        addSubview(previousButton)

        progressView = RPCircularProgress()
        progressView.progressTintColor = .white
        progressView.indeterminateProgress = 0.3
        progressView.roundedCorners = false
        addSubview(progressView)
        
        playButton = UIButton(type: .custom)
        playButton.setImage(UIImage(named: "buttonPause"), for: UIControlState())
        addSubview(playButton)
        
        updateProgress(0)
        
        constrain(skipButton, previousButton, playButton, progressView) {skip, prev, play, progress in
            
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
            
            progress.height == 136
            progress.width == 136
            progress.center == play.center

        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateProgress(_ progress: Double) {
        self.progressView.updateProgress(CGFloat(progress/100))
    }
    
    // MARK: State
    func updateState(_ state:AudioPlayerState) {
        
        let shouldLoad = (state == .buffering)
        setLoading(shouldLoad)

        switch state {
        case .buffering,
             .waitingForConnection,
             .stopped,
             .failed:
            break
        case .playing:
            play()
        case .paused:
            pause()
        }

    }
    
    func play() {
        playButton.setImage(UIImage(named: "buttonPause"), for: UIControlState())
    }
    
    func pause() {
        playButton.setImage(UIImage(named: "buttonPlay"), for: UIControlState())
    }
    
    func setLoading(_ loading: Bool) {
        if loading {
            updateProgress(10)
        }
        self.progressView.indeterminateDuration = 3
        self.progressView.enableIndeterminate(loading, completion: nil)
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
