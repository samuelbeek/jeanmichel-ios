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
    func shouldSkip(withMessage message: String)
    func progressDidChange(_ progress: Double)
    func stateDidChange(state: AudioPlayerState)
}


class SharedAudioPlayer : NSObject {
    
    internal static let instance = SharedAudioPlayer()
    
    internal var currentUrl : URL? {
        return audioPlayer.currentItem?.lowestQualityURL.url
    }
    
    fileprivate var audioPlayer : AudioPlayer!
    fileprivate var podcasts = [Podcast]() {
        didSet {
            if let items = Podcast.getAudioItemsForPodcasts(podcasts) as? [AudioItem] {
                audioPlayer.play(items: items)
            }
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
//        audioPlayer.defaultQuality = .low
        audioPlayer.retryTimeout = 15
        audioPlayer.adjustQualityAutomatically = false
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
        
        // Somehow the startAtIndex method is not 0 based
        if let index = index, index + 1 != audioPlayer.currentItemIndexInQueue, let items = audioPlayer.items {
            audioPlayer.play(items: items, startAtIndex: index + 1)
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
        if audioPlayer.hasNext {
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
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, to state: AudioPlayerState) {
        
        let state = state
        
        // Show network indicator if nessecary
        if state == .buffering {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        if case .failed(let error) = state {
            printError(0, message: error)
            delegate?.shouldSkip(withMessage: "Unfortunately this Podcast isn't available")
        } else {
            delegate?.stateDidChange(state: state)
        }
        
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, willStartPlaying item: AudioItem) {
        print("will play", NSDate())
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateProgressionTo time: TimeInterval, percentageRead: Float) {
        delegate?.progressDidChange(Double(percentageRead))
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didFindDuration duration: TimeInterval, for item: AudioItem) {
        print("did find duration")
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateEmptyMetadataOn item: AudioItem, withData data: Metadata) {
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayer, didLoad range: TimeRange, for item: AudioItem) {
        print("did load range", range)
        
        // TODO: add some sort of progress update here
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
        if let item : AudioItem = AudioItem(highQualitySoundURL: self.audioUrl, mediumQualitySoundURL: self.audioUrl, lowQualitySoundURL: self.audioUrl) {
            item.artist = self.showTitle
            item.title = self.title
            return item
        } else {
            return nil
        }
    }
}
