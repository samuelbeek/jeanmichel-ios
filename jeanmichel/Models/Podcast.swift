//
//  Podcast.swift
//  jeanmichel
//
//  Created by Samuel Beek on 19/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import Foundation

struct Podcast : Playable, Equatable {
    
    let title : String
    let showTitle: String
    let description : String
    let audioUrl : URL
    let duration : TimeInterval
    let station : String
    
    var durationString : String {
        let minutes = floor(duration/60).cleanValue
        var seconds = (duration.truncatingRemainder(dividingBy: 60)).cleanValue
        if seconds.characters.count == 1 {
            seconds = "0\(seconds)"
        }
        return "\(minutes):\(seconds)"
    }
}

func ==(lhs: Podcast, rhs: Podcast) -> Bool {
    return lhs.title == rhs.title && lhs.audioUrl == rhs.audioUrl
}

