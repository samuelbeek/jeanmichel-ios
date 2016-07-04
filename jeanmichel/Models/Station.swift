//
//  Station.swift
//  jeanmichel
//
//  Created by Samuel Beek on 20/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import Foundation

struct Station {
    let id: String
    let title : String
    
    var endpoint : String {
        return "\(API.baseUrl)"
    }
}