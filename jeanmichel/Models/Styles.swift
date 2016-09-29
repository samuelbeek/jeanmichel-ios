//
//  Styles.swift
//  jeanmichel
//
//  Created by Samuel Beek on 07/06/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit

enum Styles {
    static let stationCellHeight : CGFloat = 92
    enum Colors {
        static let stationHeaderBackgroundColor = Styles.Colors.lightPinkColor
        static let stationHeaderTextColor = Styles.Colors.whiteColor
        static let stationTextColor = Styles.Colors.darkBlueColor
        
        // colors themselves
        static let darkBlueColor = UIColor(hex: 0x071689)
        static let lightPinkColor = UIColor(hex: 0xFACEC3)
        static let whiteColor = UIColor.white

    }
    enum Fonts {
        static let stationFont = UIFont.systemFont(ofSize: 24, weight: UIFontWeightHeavy)
        static let headerFont = UIFont.systemFont(ofSize: 26, weight: UIFontWeightHeavy)
    }
}
