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
    
    var dataSource : CollectionViewDataSourceProxy!
    let station : Station
    var podcasts : [Podcast] = []
    var collectionView : UICollectionView!
    var playerView : PlayerView!
    
    
    init(station: Station) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .clearColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = station.title
        let source = PodcastDataSource()
        let proxy = CollectionViewDataSourceProxy(dataSource: source)
        dataSource = proxy
        
        NSNotificationCenter.defaultCenter().addObserverForName(JukeBoxNotificationError, object: nil, queue: nil, usingBlock: { [unowned self] notification in
            
            guard let userInfo = notification.userInfo, let message = userInfo[JukeBoxKeyErrorMessage] as? String, let code : Int = userInfo[JukeBoxKeyErrorCode] as? Int else {
                return
            }
            
            print(message)
            
            
            
            if code == -1100 {
                self.showSkipAlert()
            }
            
            if let url : String = userInfo[JukeBoxKeyAssetURL] as? String,
                let assetUrl = NSURL(string: url),
                let currentUrl = AudioPlayer.instance.currentUrl where currentUrl == assetUrl {
                self.showSkipAlert()
            }
            
        })

        // layout stuff
        let layout: UICollectionViewFlowLayout = CenterCellCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsZero
        layout.itemSize = view.bounds.size
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = dataSource
        collectionView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.registerClass(PodcastCollectionViewCell.self, forCellWithReuseIdentifier: Constants.defaultCellIdentifier)
        collectionView.reloadData()
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        playerView = PlayerView(frame: view.bounds, station: self.station)
        playerView.skipButton.addTarget(self, action: #selector(self.skip), forControlEvents: .TouchUpInside)
        playerView.previousButton.addTarget(self, action: #selector(self.previous), forControlEvents: .TouchUpInside)
        playerView.playButton.addTarget(self, action: #selector(self.playPause), forControlEvents: .TouchUpInside)
        view.addSubview(playerView)
        
        
        API.getPodcasts(self.station) { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
                
            case .Value(let podcasts):
                strongSelf.podcasts =  podcasts.shuffle()
                source.data = strongSelf.podcasts
                AudioPlayer.instance.setItems(strongSelf.podcasts)
                AudioPlayer.instance.play()
                strongSelf.collectionView.reloadData()
                break
            case .Error(let error):
                print(error)
            }
            
        }
        
    }
    
    func setCurrentIndexPath(indexPath: NSIndexPath) {
        AudioPlayer.instance.play(indexPath.row)
        play()
    }

    func skip() {
        for cell in self.collectionView.visibleCells() {
            if let indexPath = self.collectionView.indexPathForCell(cell) {
                let nextIndexPath = NSIndexPath(forItem: indexPath.item+1, inSection: indexPath.section)
                if let _ = podcasts[safe: nextIndexPath.row] {
                    self.collectionView.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: .CenteredHorizontally, animated: true)
                    setCurrentIndexPath(nextIndexPath)
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
   
    func play() {
        AudioPlayer.instance.play()
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
    
    func showSkipAlert() {
        AudioPlayer.instance.pause()
        self.showAlert(String.localize("Can't be played"),
                       message: String.localize("This podcast can't be played. Sorry! Is it OK if we skip to the next one?"),
                       button: String.localize("Skip"),
                       handler: { [unowned self] _ in
                        self.skip()
            })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

