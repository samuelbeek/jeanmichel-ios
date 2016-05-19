//
//  Audioplayer.swift
//  jeanmichel
//
//  Created by Samuel Beek on 20/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import Jukebox
import UIKit

class AudioPlayer : NSObject {
    
    static let instance = AudioPlayer()
    
    private var audioPlayer : Jukebox!
    private var podcasts = [Podcast]() {
        didSet {
            audioPlayer = Jukebox(delegate: self, items: Podcast.getJukeBoxItemsForPodcasts(podcasts))
        }
    }

    override init() {
        super.init()
        audioPlayer = Jukebox(delegate: self, items: [])
    }
    
    internal func setItems(podcasts: [Podcast]) {
        self.podcasts = podcasts
    }
    
    internal func play(index: Int? = 0) {
        self.play(index)
    }

}

extension AudioPlayer : JukeboxDelegate {
    func jukeboxStateDidChange(jukebox : Jukebox) {
        
    }
    func jukeboxPlaybackProgressDidChange(jukebox : Jukebox) {
        
    }
    func jukeboxDidLoadItem(jukebox : Jukebox, item : JukeboxItem) {
        
    }
    
}