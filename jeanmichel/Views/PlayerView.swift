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
    
    var titleLabel : UILabel!
    var podcast : Podcast? {
        didSet {
            if let podast = podcast {
                titleLabel.text = podast.title
            } else {
                titleLabel.text = "no track"
            }
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
        titleLabel.textColor = .whiteColor()
        titleLabel.textAlignment = .Center
        addSubview(titleLabel)
        
        constrain(titleLabel) { title in
            title.width == title.superview!.width - 100
            title.height == 24
            title.center == title.superview!.center
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}