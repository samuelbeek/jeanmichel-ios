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
    
    internal var currentUrl : NSURL? {
        return audioPlayer.currentItem?.URL
    }
    
    private var audioPlayer : Jukebox!
    private var podcasts = [Podcast]() {
        didSet {
            
            var playIndex : Int? = nil
            if (isPlaying) {
                playIndex = self.audioPlayer.playIndex
            }
            
            audioPlayer.stop()
            audioPlayer = nil
            audioPlayer = Jukebox(delegate: self, items: Podcast.getJukeBoxItemsForPodcasts(podcasts))
            if let index = playIndex {
                audioPlayer.play(atIndex: index)
            }
        }
    }
    
    internal var isPlaying : Bool {
        return audioPlayer.state == Jukebox.State.Playing
    }
    
    internal var state : Jukebox.State {
        return audioPlayer.state
    }

    private override init() {
        super.init()
        audioPlayer = Jukebox(delegate: self, items: [])
    }
    
    
    internal func setItems(podcasts: [Podcast]) {
        self.podcasts = podcasts
    }
    
    internal func pause() {
        audioPlayer.pause()
    }
    
    internal func play(index: Int? = nil) {
        if let i = index where index != audioPlayer.playIndex{
            audioPlayer.play(atIndex: i)
        } else {
            audioPlayer.play()
        }
    }
    
    internal func stop() {
        audioPlayer.stop()
    }

}

extension AudioPlayer : JukeboxDelegate {
    func jukeboxStateDidChange(state : Jukebox) {
        print("jukeBoxDidChange")
    }
    
    func jukeboxPlaybackProgressDidChange(jukebox : Jukebox) {
        print("jukeBoxPlaybackPRogressDidChange")
    }
    
    func jukeboxDidLoadItem(jukebox : Jukebox, item : JukeboxItem) {
        print("jukeBoxDidLoad")
    }
    
    func jukeboxDidUpdateMetadata(jukebox : Jukebox, forItem: JukeboxItem) {
        print("jukeBoxDidUpdateMetaData")
    }
}