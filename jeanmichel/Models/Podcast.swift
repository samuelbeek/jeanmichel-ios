//
//  Podcast.swift
//  jeanmichel
//
//  Created by Samuel Beek on 19/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import Foundation
import Jukebox

struct Podcast {
    let title : String
    let description : String
    let audioUrl : NSURL
    
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
