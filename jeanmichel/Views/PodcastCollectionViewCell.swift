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
    
    var titleLabel, showLabel, durationLabel : UILabel!
    var backgroundImageView : UIImageView!
    var podcast : Podcast? {
        didSet {
            if let podcast = podcast {
                titleLabel.text = podcast.title
                showLabel.text = podcast.showTitle
                durationLabel.text = podcast.durationString
            } else {
                titleLabel.text = "no track"
                showLabel.text = ""
                durationLabel.text = ""
            }
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .scaleToFill
        addSubview(backgroundImageView)

        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        showLabel = UILabel()
        showLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)
        showLabel.textColor = .white
        showLabel.textAlignment = .center
        addSubview(showLabel)

        durationLabel = UILabel()
        durationLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)
        durationLabel.textColor = .white
        durationLabel.textAlignment = .center
        addSubview(durationLabel)
        
        constrain(titleLabel, showLabel, durationLabel, backgroundImageView) { title, show, duration, bg in
            
            duration.size == title.size
            duration.centerX == duration.superview!.centerX
            duration.top == title.bottom + 5
            
            show.size == title.size
            show.centerX == show.superview!.centerX
            show.bottom == title.top - 5
            
            title.width == title.superview!.width - 160
            title.height == 24
            title.centerX == title.superview!.centerX
            title.bottom == title.superview!.bottom - 45
            
            bg.size == bg.superview!.size
            bg.center == bg.superview!.center
        }
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
