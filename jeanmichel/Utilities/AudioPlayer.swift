//
//  Audioplayer.swift
//  jeanmichel
//
//  Created by Samuel Beek on 20/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit
import AVFoundation
import KDEAudioPlayer

protocol SharedAudioPlayerDelegate : class {
    func progressDidChange(_ progress: Double)
    func stateDidChange(state: AudioPlayerState)
}


class SharedAudioPlayer : NSObject {
    
    internal static let instance = SharedAudioPlayer()
    
    internal var currentUrl : URL? {
        return audioPlayer.currentItem?.mediumQualityURL.URL
    }
    
    fileprivate var audioPlayer : AudioPlayer!
    fileprivate var podcasts = [Podcast]() {
        didSet {
            audioPlayer.playItems(Podcast.getAudioItemsForPodcasts(podcasts) as! [AudioItem], startAtIndex: 0)
        }
    }
    
    /// Return players state
    internal var state : AudioPlayerState {
        return audioPlayer.state
    }
    
    internal weak var delegate : SharedAudioPlayerDelegate?

    fileprivate override init() {
        super.init()
        startRemote()
        audioPlayer = AudioPlayer()
        audioPlayer.delegate = self
    }
    
    // MARK: Load Data
    /// Change content
    internal func setItems(_ podcasts: [Podcast]) {
        self.podcasts = podcasts
    }
    
    /// Remove all Content
    internal func reset() {
        stop()
        self.podcasts = []
    }
    
    // MARK: Playback
    /// Pause index
    internal func pause() {
        audioPlayer.pause()
    }
    
    /// Play at index
    internal func play(_ index: Int? = nil) {
        if let i = index ,index != audioPlayer.currentItemIndexInQueue, let items = audioPlayer.items {
            audioPlayer.playItems(items, startAtIndex: i)
        } else {
            audioPlayer.resume()
        }
    }
    
    /// Stop playback
    internal func stop() {
        audioPlayer.stop()
    }
    
    /// Play next track
    internal func playNext() {
        if audioPlayer.hasNext() {
            audioPlayer.next()
        } else {
            printError(002, message: "AudioPlayer doesn't have a next track")
        }
        
    }
    
    /// Play previous track
    internal func playPrevious() {
        audioPlayer.previous()
    }
    
    // MARK: Remote Events
    /// Starts listening to remote events (controls on the lock screen)
    fileprivate func startRemote() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
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

extension SharedAudioPlayer : AudioPlayerDelegate {
    
    public func audioPlayer(_ audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, toState to: AudioPlayerState) {
        if to == .buffering {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        delegate?.stateDidChange(state: to)
    }
    
    public func audioPlayer(_ audioPlayer: AudioPlayer, willStartPlayingItem item: AudioItem) {
    }
    
    public func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateProgressionToTime time: TimeInterval, percentageRead: Float) {
        delegate?.progressDidChange(Double(percentageRead))
    }
    
    public func audioPlayer(_ audioPlayer: AudioPlayer, didFindDuration duration: TimeInterval, forItem item: AudioItem) {
    }
    
    public func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateEmptyMetadataOnItem item: AudioItem, withData data: Metadata) {
    }
    
    public func audioPlayer(_ audioPlayer: AudioPlayer, didLoadRange range: AudioPlayer.TimeRange, forItem item: AudioItem) {
    }

    func audioPlayer(audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, toState to: AudioPlayerState) {

    }
    
    
}

extension Podcast {
    static func getAudioItemsForPodcasts(_ podcasts : [Podcast]) -> [AudioItem?] {
        return podcasts.map { podcast -> AudioItem? in
            return podcast.getAudioItemForPodcast()
        }
    }
    
    /// Converts Podcast into AudioItem (which is playabale by our AudioPlayer)
    func getAudioItemForPodcast() -> AudioItem? {
        if let item : AudioItem = AudioItem(highQualitySoundURL: nil, mediumQualitySoundURL: self.audioUrl, lowQualitySoundURL: nil) {
            item.artist = self.showTitle
            item.title = self.title
            return item
        } else {
            return nil
        }
    }
}
