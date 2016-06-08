//
//  ChannelTableViewCell.swift
//  jeanmichel
//
//  Created by Samuel Beek on 07/06/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit

class ChannelTableViewCell : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.font  = Styles.stationFont
        textLabel?.textColor = .blackColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
