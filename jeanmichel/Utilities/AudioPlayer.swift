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
            
            // init an audioPlayer if there's no items
            if audioPlayer.queuedItems.count <= 0 {
                self.audioPlayer = Jukebox(delegate: self, items: Podcast.getJukeBoxItemsForPodcasts(self.podcasts))
            } else {
                // remove diff
                for oldPodcast in oldValue {
                    if !podcasts.contains(oldPodcast) {
                        self.audioPlayer.removeItems(withURL: oldPodcast.audioUrl)
                    }
                }
                
                // add diff
                for newPodcast in podcasts {
                    if !oldValue.contains(newPodcast) {
                        self.audioPlayer.append(item: newPodcast.getJukeBoxItemForPodcast(), loadingAssets: true)
                    }
                }
            }
            

        }
    }
    
    /// Return if player is playing
    internal var isPlaying : Bool {
        return audioPlayer.state == .Playing
    }
    
    /// Return players state
    internal var state : Jukebox.State {
        return audioPlayer.state
    }
    
    internal weak var delegate : AudioPlayerDelegate?

    private override init() {
        super.init()
        audioPlayer = Jukebox(delegate: self, items: [])
    }
    
    /// Change content
    internal func setItems(podcasts: [Podcast]) {
        self.podcasts = podcasts
    }
    
    /// Pause index
    internal func pause() {
        audioPlayer.pause()
    }
    
    /// Play at index
    internal func play(index: Int? = nil) {
        if let i = index where index != audioPlayer.playIndex{
            audioPlayer.play(atIndex: i)
        } else {
            audioPlayer.play()
        }
    }
    
    /// Stop playback
    internal func stop() {
        audioPlayer.stop()
    }
    
    /// Play next track
    internal func playNext() {
        audioPlayer.playNext()
    }
    
    /// Play previous track
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