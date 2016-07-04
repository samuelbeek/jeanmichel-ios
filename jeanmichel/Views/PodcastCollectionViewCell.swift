//
//  PodcastCollectionViewCell.swift
//  jeanmichel
//
//  Created by Samuel Beek on 04/07/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit
import Cartography

class PodcastCollectionViewCell : UICollectionViewCell {
    
    var titleLabel, showLabel : UILabel!
    var podcast : Podcast? {
        didSet {
            if let podcast = podcast {
                titleLabel.text = podcast.title
                showLabel.text = podcast.showTitle
            } else {
                titleLabel.text = "no track"
                showLabel.text = ""
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
        
        showLabel = UILabel()
        showLabel.font = UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
        showLabel.textColor = .whiteColor()
        showLabel.textAlignment = .Center
        addSubview(showLabel)

        
        constrain(titleLabel, showLabel) { title, show in
            
            show.size == title.size
            show.centerX == show.superview!.centerX
            show.bottom == title.top - 5
            
            title.width == title.superview!.width - 100
            title.height == 24
            title.centerX == title.superview!.centerX
            title.bottom == title.superview!.bottom - 80
        }
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}