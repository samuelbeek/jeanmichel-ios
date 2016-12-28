//
//  InfoView.swift
//  jeanmichel
//
//  Created by Samuel Beek on 28/12/2016.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit
import Cartography

class InfoView : UIView {
    
    let infoTextView = UITextView.init(frame: CGRect.zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let attributedStringParagraphStyle = NSMutableParagraphStyle()
        attributedStringParagraphStyle.alignment = NSTextAlignment.left
        
        let attributedString = NSMutableAttributedString(string: "On The Air is for listening\nto podcasts.\n\nPick a topic you like and start listening.")
        
        attributedString.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize: 26, weight: UIFontWeightBold), range:NSMakeRange(0,84))
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:attributedStringParagraphStyle, range:NSMakeRange(0,84))
        attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.024, green:0.161, blue:0.608, alpha:1.0), range:NSMakeRange(0,10))
        attributedString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0), range:NSMakeRange(10,74))
        
        infoTextView.attributedText = attributedString
        infoTextView.backgroundColor = Styles.Colors.lightPinkColor
        infoTextView.isUserInteractionEnabled = false
        addSubview(infoTextView)

        constrain(infoTextView) { info in
            info.left == info.superview!.left + 30
            info.right == info.superview!.right - 30
            info.centerY == info.superview!.centerY - 100
        }
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        infoTextView.sizeToFit()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
