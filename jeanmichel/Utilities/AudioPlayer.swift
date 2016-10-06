//
//  Audioplayer.swift
//  jeanmichel
//
//  Created by Samuel Beek on 20/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import Jukebox
import UIKit
import AVFoundation

protocol AudioPlayerDelegate : class {
    func progressDidChange(_ progress: Double)
    func stateDidChange(state: Jukebox.State)
}


class AudioPlayer : NSObject {
    
    internal static let instance = AudioPlayer()
    
    internal var currentUrl : URL? {
        return audioPlayer.currentItem?.URL
    }
    
    fileprivate var audioPlayer : Jukebox!
    fileprivate var podcasts = [Podcast]() {
        didSet {
            
            // init an audioPlayer if there's no items
            if audioPlayer.queuedItems.count <= 0 {
                self.audioPlayer = Jukebox(delegate: self, items: Podcast.getJukeBoxItemsForPodcasts(self.podcasts))
            } else {
                
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
    
    /// Return players state
    internal var state : Jukebox.State {
        return audioPlayer.state
    }
    
    internal weak var delegate : AudioPlayerDelegate?

    fileprivate override init() {
        super.init()
        startRemote()
        audioPlayer = Jukebox(delegate: self, items: [])
    }
    
    // MARK: Load Data
    /// Change content
    internal func setItems(_ podcasts: [Podcast]) {
        self.podcasts = podcasts
    }
    
    /// Remove all Content
    internal func reset() {
        stop()
        for item in self.audioPlayer.queuedItems {
            self.audioPlayer.remove(item: item)
        }
    }
    
    // MARK: Playback
    /// Pause index
    internal func pause() {
        audioPlayer.pause()
    }
    
    /// Play at index
    internal func play(_ index: Int? = nil) {
        if let i = index , index != audioPlayer.playIndex{
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
    
    // MARK: Remote Events
    /// Starts listening to remote events (controls on the lock screen)
    fileprivate func startRemote() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            printError(00, message: "unable to set audio category")
        }
    }
    
    /// Stops listening to remote events
    internal func stopRemote() {
       // UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    //MARK: Debugging
    internal func printPodcasts() {
        debugPrint("🌎 AudioPlayer.podcasts: ")
        
        for podcast in podcasts {
            debugPrint(podcast.title)
        }
    }
    
}

extension AudioPlayer : JukeboxDelegate {
    func jukeboxStateDidChange(_ state : Jukebox) {
        
       delegate?.stateDidChange(state: state.state)
        
        if state.state == .loading {
           UIApplication.shared.isNetworkActivityIndicatorVisible = true
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    }
    
    func jukeboxPlaybackProgressDidChange(_ jukebox : Jukebox) {
        if let delegate = delegate, let currentItem = jukebox.currentItem, let currentTime = currentItem.currentTime, let duration = currentItem.meta.duration {
            let progress = (currentTime/duration)*100
            delegate.progressDidChange(progress)
        }
    }
    
    func jukeboxDidLoadItem(_ jukebox : Jukebox, item : JukeboxItem) {
    }
    
    func jukeboxDidUpdateMetadata(_ jukebox : Jukebox, forItem: JukeboxItem) {
    }
    
}
