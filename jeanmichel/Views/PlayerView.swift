//
//  PlayerView.swift
//  jeanmichel
//
//  Created by Samuel Beek on 04/07/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit
import Cartography

class PlayerView : UIView {
    
    var stationLabel : UILabel!
    var skipButton, previousButton, playButton : UIButton!
    
    init(frame: CGRect, station: Station) {
        
        super.init(frame: frame)
        
        skipButton = UIButton(type: .Custom)
        skipButton.setImage(UIImage(named: "buttonSkip"), forState: .Normal)
        addSubview(skipButton)
        
        previousButton = UIButton(type: .Custom)
        previousButton.setImage(UIImage(named: "buttonPrevious"), forState: .Normal)
        addSubview(previousButton)

        playButton = UIButton(type: .Custom)
        playButton.setImage(UIImage(named: "buttonPause"), forState: .Normal)
        addSubview(playButton)

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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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