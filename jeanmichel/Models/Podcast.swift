//
//  Podcast.swift
//  jeanmichel
//
//  Created by Samuel Beek on 19/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import Foundation
import Jukebox

struct Podcast : Playable {
    
    let title : String
    let showTitle: String
    let description : String
    let audioUrl : NSURL
    let duration : NSTimeInterval
    
    var durationString : String {
        let minutes = floor(duration/60).cleanValue
        var seconds = (duration%60).cleanValue
        if seconds.characters.count == 1 {
            seconds = "0\(seconds)"
        }
        return "\(minutes):\(seconds)"
    }
    
    static func getUrlsForPodcasts(podcasts : [Podcast]) -> [NSURL] {
        return podcasts.map { podcast -> NSURL in
            return podcast.audioUrl
        }
    }
    
    static func getJukeBoxItemsForPodcasts(podcasts : [Podcast]) -> [JukeboxItem] {
        return getUrlsForPodcasts(podcasts).map { url -> JukeboxItem in
            return JukeboxItem(URL: url)
        }
    }
 }
