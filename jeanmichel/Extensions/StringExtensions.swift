//
//  StringExtensions.swift
//  jeanmichel
//
//  Created by Samuel Beek on 22/07/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit

extension String {
    
    /// Use: String.localize("Open the gate")
    static func localize(key: String) -> String {
        return NSLocalizedString(key, comment: "") ?? key
    }
    
}
