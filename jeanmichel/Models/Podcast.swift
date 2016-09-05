//
//  Podcast.swift
//  jeanmichel
//
//  Created by Samuel Beek on 19/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import Foundation
import Jukebox

struct Podcast : Playable, Equatable {
    
    let title : String
    let showTitle: String
    let description : String
    let audioUrl : NSURL
    let duration : NSTimeInterval
    let station : String
    
    var durationString : String {
        let minutes = floor(duration/60).cleanValue
        var seconds = (duration%60).cleanValue
        if seconds.characters.count == 1 {
            seconds = "0\(seconds)"
        }
        return "\(minutes):\(seconds)"
    }
    
    static func getJukeBoxItemsForPodcasts(podcasts : [Podcast]) -> [JukeboxItem] {
        return podcasts.map { podcast -> JukeboxItem in
            return podcast.getJukeBoxItemForPodcast()
        }
    }
    
    func getJukeBoxItemForPodcast() -> JukeboxItem {
        return JukeboxItem(URL: audioUrl, localTitle: title)
    }
 }

func ==(lhs: Podcast, rhs: Podcast) -> Bool {
    return lhs.title == rhs.title && lhs.audioUrl == rhs.audioUrl
}

