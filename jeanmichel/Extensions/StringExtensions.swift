//
//  StringExtensions.swift
//  jeanmichel
//
//  Created by Samuel Beek on 22/07/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit

extension String {
    
    /// Use:  String.localized("Open the gate")
    static func localized(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
}
