//
//  MasterViewController.swift
//  jeanmichel
//
//  Created by Samuel Beek on 20/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit
import Jukebox

class MasterViewController : UINavigationController {
    
    private var audioPlayer : Jukebox!
    private var podcasts = [Podcast]() {
        didSet {
            audioPlayer = Jukebox(delegate: self, items: Podcast.getJukeBoxItemsForPodcasts(podcasts))
        }
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.audioPlayer = Jukebox(delegate: self, items: [])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setItems(podcasts: [Podcast]) {
       self.podcasts = podcasts
    }
    
    internal func play(index: Int? = 0) {
        self.play(index)
    }
    
}

extension MasterViewController : JukeboxDelegate {
    func jukeboxStateDidChange(jukebox : Jukebox) {
        
    }
    func jukeboxPlaybackProgressDidChange(jukebox : Jukebox) {
        
    }
    func jukeboxDidLoadItem(jukebox : Jukebox, item : JukeboxItem) {
        
    }
    
}