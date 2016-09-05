//
//  Audioplayer.swift
//  jeanmichel
//
//  Created by Samuel Beek on 20/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import Jukebox
import UIKit

protocol AudioPlayerDelegate : class {
    func progressDidChange(progress: Double)
}

class AudioPlayer : NSObject {
    
    internal static let instance = AudioPlayer()
    
    internal var currentUrl : NSURL? {
        return audioPlayer.currentItem?.URL
    }
    
    private var audioPlayer : Jukebox!
    private var podcasts = [Podcast]() {
        didSet {
            dispatch_async(dispatch_get_main_queue(),{
                var playIndex : Int? = nil
                if (self.isPlaying) {
                    playIndex = self.audioPlayer.playIndex
                }
    
                self.audioPlayer.stop()
                self.audioPlayer = nil // We have to make audioPlayer nil before we create a new one
                self.audioPlayer = Jukebox(delegate: self, items: Podcast.getJukeBoxItemsForPodcasts(self.podcasts))
                
                if let index = playIndex {
                    self.audioPlayer.play(atIndex: index)
                }

            })
        }
    }
    
    internal var isPlaying : Bool {
        return audioPlayer.state == .Playing || audioPlayer.state == .Loading
    }
    
    internal var state : Jukebox.State {
        return audioPlayer.state
    }
    
    internal weak var delegate : AudioPlayerDelegate?

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
    
    internal func playNext() {
        audioPlayer.playNext()
    }
    
    internal func playPrevious() {
        audioPlayer.playPrevious()
    }
    
    /// Starts listening to remote events (controls on the lock screen)
    internal func startRemote() {
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    /// Stops listening to remote events
    internal func stopRemote() {
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
    }
    
}

extension AudioPlayer : JukeboxDelegate {
    func jukeboxStateDidChange(state : Jukebox) {
        
        if state.state == .Loading {
           UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
    }
    
    func jukeboxPlaybackProgressDidChange(jukebox : Jukebox) {
        if let delegate = delegate, let currentItem = jukebox.currentItem, currentTime = currentItem.currentTime, duration = currentItem.meta.duration {
            let progress = (currentTime/duration)*100
            delegate.progressDidChange(progress)
        }
    }
    
    func jukeboxDidLoadItem(jukebox : Jukebox, item : JukeboxItem) {
    }
    
    func jukeboxDidUpdateMetadata(jukebox : Jukebox, forItem: JukeboxItem) {
    }
    
}