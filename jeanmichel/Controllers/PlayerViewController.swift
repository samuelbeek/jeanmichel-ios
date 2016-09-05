//
//  EpisodeViewController.swift
//  jeanmichel
//
//  Created by Samuel Beek on 20/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit
import Jukebox
import Cartography

class PlayerViewController : UIViewController {
    
    private let station : Station
    private var podcasts : [Podcast] = []
    private var collectionView : UICollectionView!
    private var playerView : PlayerView!
    private var currentIndexPath : NSIndexPath?
    
    init(station: Station) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clearColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = station.title

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        // If there's an error, deal with it
        NSNotificationCenter.defaultCenter().addObserverForName(JukeBoxNotificationError, object: nil, queue: nil, usingBlock: { [weak self] notification in
            if let strongSelf = self {
                strongSelf.handleErrorNotification(notification)
            } else {
                print("self doesn't exist anymore")
            }
        })

        // CollectionViewLayout
        let layout: UICollectionViewFlowLayout = CenterCellCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsZero
        layout.itemSize = view.bounds.size
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        // CollectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.registerClass(PodcastCollectionViewCell.self, forCellWithReuseIdentifier: Constants.defaultCellIdentifier)
        collectionView.reloadData()
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        // PlayerView (the controls form the player aren't part of the cells)
        playerView = PlayerView(frame: view.bounds, station: self.station)
        playerView.skipButton.addTarget(self, action: #selector(self.skip), forControlEvents: .TouchUpInside)
        playerView.previousButton.addTarget(self, action: #selector(self.previous), forControlEvents: .TouchUpInside)
        playerView.playButton.addTarget(self, action: #selector(self.playPause), forControlEvents: .TouchUpInside)
        view.addSubview(playerView)
        
        fetchData()
    }
    
    
    func fetchData() {
        API.getPodcasts(self.station) { [weak self] result in
            
            switch result {
            case .Value(let podcasts):
                self?.podcasts = podcasts.shuffle()
                self?.collectionView.reloadData()
                self?.reloadPlayer()
                self?.play()
                break
            case .Error(let error):
                print(error)
            }
            
        }
    }
    
    
    func setCurrentIndexPath(indexPath: NSIndexPath) {
        currentIndexPath = indexPath
        self.play(index: indexPath.row)
    }
    
    func reloadPlayer() {
        // TODO: make sure we have the correct time?
        AudioPlayer.instance.setItems(self.podcasts)
    }

    func skip() {
        for cell in self.collectionView.visibleCells() {
            if let indexPath = self.collectionView.indexPathForCell(cell) {
                let nextIndexPath = NSIndexPath(forItem: indexPath.item+1, inSection: indexPath.section)
                if let _ = podcasts[safe: nextIndexPath.row] {
                    self.collectionView.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: .CenteredHorizontally, animated: true)
                    setCurrentIndexPath(nextIndexPath)
                    self.play()
                }
            }
        }
    }
    
    func playPause() {
        if AudioPlayer.instance.state == .Playing {
            pause()
        } else {
            play()
        }
    }
   
    func play(index index: Int? = nil) {
        AudioPlayer.instance.play(index)
        playerView.play()
    }
    
    func pause() {
        AudioPlayer.instance.pause()
        playerView.pause()
    }
    
    func previous() {
        for cell in self.collectionView.visibleCells() {
            if let indexPath = self.collectionView.indexPathForCell(cell) {
                let nextIndexPath = NSIndexPath(forItem: indexPath.item-1, inSection: indexPath.section)
                if let _ = podcasts[safe: nextIndexPath.row] {
                    self.collectionView.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: .CenteredHorizontally, animated: true)
                    setCurrentIndexPath(nextIndexPath)
                }
            }
        }
    }
    
    // MARK : Notification 
    func handleErrorNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo, let message = userInfo[JukeBoxKeyErrorMessage] as? String, let code : Int = userInfo[JukeBoxKeyErrorCode] as? Int else {
            return
        }
        
        printError(code, message: message)
        
        if let url = userInfo[JukeBoxKeyAssetURL] as? NSURL {
            if let currentUrl = AudioPlayer.instance.currentUrl where url == currentUrl {
                // show an alert if we're on the current page
                showSkipAlert(url)
                
            } else {
                removePodcastWithUrl(url)
            }
        }
    }
    
    func removePodcastWithUrl(url: NSURL) {
        if let podcast = getPodcastWithAudioUrl(url), let index = podcasts.indexOf(podcast) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0) // note: this has to be section 0
            collectionView.performBatchUpdates({
                self.podcasts.removeObject(podcast)
                
                // after the podcasts have been updated, reload the player and collectionView
                self.reloadPlayer()
                self.collectionView.deleteItemsAtIndexPaths([indexPath])
                }, completion: { _ in
                    printError(0, message: "\(podcast.title) wouldn't play, we removed the cell at indexPath: \(indexPath.description))")
                    self.play()

            })
            
        }
    }
    
    /// Returns podcast object that's in the current scrope with the same url, if it's there
    func getPodcastWithAudioUrl(audioUrl: NSURL) -> Podcast? {
        for podcast in podcasts {
            if podcast.audioUrl == audioUrl {
                return podcast
            }
        }
        return nil
    }
    
    func showSkipAlert(url: NSURL) {
        skip()
        self.showAlert(String.localize("Can't be played"),
                       message: String.localize("This podcast can't be played. Sorry! Is it OK if we skip to the next one?"),
                       button: String.localize("Skip"),
                       handler: { [unowned self] _ in
                        self.removePodcastWithUrl(url)
            })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PlayerViewController : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.defaultCellIdentifier, forIndexPath: indexPath) as? PodcastCollectionViewCell, let podcast = podcasts[safe: indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.podcast = podcast
        if let image = UIImage(named: "bg-\(podcast.station)-\(Int(arc4random_uniform(4))+1)") {
            cell.backgroundImageView.image = image
        } else {
            cell.backgroundColor = UIColor.randomColor(0.5)
        }
        return cell
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
}

extension PlayerViewController : UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(podcasts[indexPath.row].title)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        for cell in self.collectionView.visibleCells() {
            if let indexPath = self.collectionView.indexPathForCell(cell) {
                setCurrentIndexPath(indexPath)
            }
        }
    }
}

