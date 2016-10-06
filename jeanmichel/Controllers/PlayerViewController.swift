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
    
    fileprivate let station : Station
    fileprivate var podcasts : [Podcast] = []
    fileprivate var collectionView : UICollectionView!
    fileprivate var playerView : PlayerView!
    fileprivate var currentIndexPath : IndexPath?
    
    init(station: Station) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
        AudioPlayer.instance.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }
    
    // MARK: View LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        AudioPlayer.instance.startRemote()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = station.title
        view.backgroundColor = Styles.Colors.lightPinkColor
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        // If there's an error, deal with it
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: JukeBoxNotificationError), object: nil, queue: nil, using: { [weak self] notification in
            
            guard let strongSelf = self else {
                return printError(001, message: "self doesn't exist anymore")
            }
            
            strongSelf.handleErrorNotification(notification)
        })
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil, using: { [weak self]  _ in
            guard let strongSelf = self else {
                return printError(001, message: "self doesn't exist anymore")
            }
            
            strongSelf.skip()
        })



        // CollectionViewLayout
        let layout: UICollectionViewFlowLayout = CenterCellCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.itemSize = view.bounds.size
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        constrain(activityIndicator) { spinner in
            spinner.center == spinner.superview!.center
        }
        
        // CollectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.register(PodcastCollectionViewCell.self, forCellWithReuseIdentifier: Constants.defaultCellIdentifier)
        collectionView.reloadData()
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        // PlayerView (the controls form the player aren't part of the cells)
        playerView = PlayerView(frame: view.bounds, station: self.station)
        playerView.skipButton.addTarget(self, action: #selector(self.skip), for: .touchUpInside)
        playerView.previousButton.addTarget(self, action: #selector(self.previous), for: .touchUpInside)
        playerView.playButton.addTarget(self, action: #selector(self.playPause), for: .touchUpInside)
        view.addSubview(playerView)
        
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    // MARK : Fetch Data
    
    func fetchData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        API.getPodcasts(self.station) { [weak self] result in
            
            switch result {
            case .value(let podcasts):
                self?.podcasts = podcasts.shuffled()
                self?.collectionView.reloadData()
                self?.reloadPlayer()
                self?.play()
                break
            case .error(let error):
                print(error)
            }
            
        }
    }
    
    // MARK: Handle paging and what to play
    func setCurrentPage() {
        for cell in self.collectionView.visibleCells {
            if let indexPath = self.collectionView.indexPath(for: cell) {
                setCurrentIndexPath(indexPath)
            }
        }
    }
    
    func setCurrentIndexPath(_ indexPath: IndexPath) {
        if currentIndexPath != indexPath {
            currentIndexPath = indexPath
            play(index: (indexPath as NSIndexPath).row)
        }
    }
    
    func reloadPlayer() {
        AudioPlayer.instance.setItems(self.podcasts)
        AudioPlayer.instance.printPodcasts()
        printPodcasts()
    }
    
    // MARK: Play and pause
    func playPause() {
        if AudioPlayer.instance.state == .playing {
            pause()
        } else {
            play()
        }
    }
   
    func play(index: Int? = nil) {
        AudioPlayer.instance.play(index)
        playerView.play()
    }
    
    func pause() {
        AudioPlayer.instance.pause()
        playerView.pause()
    }
    
    // MARK: Next and Previous
    
    func previous() {
        for cell in self.collectionView.visibleCells {
            if let indexPath = self.collectionView.indexPath(for: cell) {
                let nextIndexPath = IndexPath(item: (indexPath as NSIndexPath).item-1, section: (indexPath as NSIndexPath).section)
                if let _ = podcasts[safe: (nextIndexPath as NSIndexPath).row] {
                    self.collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
    
    func skip() {
        for cell in self.collectionView.visibleCells {
            if let indexPath = self.collectionView.indexPath(for: cell) {
                let nextIndexPath = IndexPath(item: (indexPath as NSIndexPath).item+1, section: (indexPath as NSIndexPath).section)
                if let _ = podcasts[safe: (nextIndexPath as NSIndexPath).row] {
                    self.collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
                }
            }
        }
    }

    
    // MARK : Notification 
    func handleErrorNotification(_ notification: Notification) {
        
        guard let userInfo = (notification as NSNotification).userInfo, let message = userInfo[JukeBoxKeyErrorMessage] as? String, let code : Int = userInfo[JukeBoxKeyErrorCode] as? Int else {
            printError(999, message: "received error that could not be parsed \(notification)")
            return
        }
        
        printError(code, message: message)
        
        if let url = userInfo[JukeBoxKeyAssetURL] as? NSURL {
            if let currentIndexPath = currentIndexPath, let currentUrl : URL = self.podcasts[currentIndexPath.item].audioUrl, url as URL == currentUrl {
                
                // show an alert if we're on the current page
                showSkipAlert(url as URL)
            } else {
                removePodcastWithUrl(url as URL)
            }
        }
    }
    
    func removePodcastWithUrl(_ url: URL, skip: Bool = false) {
        if let podcast = getPodcastWithAudioUrl(url), let index = podcasts.index(of: podcast) {
            let indexPath = IndexPath(row: index, section: 0) // note: this has to be section 0
            collectionView.performBatchUpdates({
                self.podcasts.removeObject(podcast)
                // after the podcasts have been updated, reload the player and collectionView
                self.reloadPlayer()
                self.collectionView.deleteItems(at: [indexPath])
                self.collectionView.reloadData()
                }, completion: { _ in
                    printError(0, message: "\(podcast.title) wouldn't play, we removed the cell at indexPath: \(indexPath.description))")
                    self.setCurrentPage()
                    
            })
            
        }
    }
    
    /// Returns podcast object that's in the current scrope with the same url, if it's there
    func getPodcastWithAudioUrl(_ audioUrl: URL) -> Podcast? {
        for podcast in podcasts {
            if podcast.audioUrl as URL == audioUrl {
                return podcast
            }
        }
        return nil
    }
    
    func showSkipAlert(_ url: URL) {
        self.showAlert(String.localized("Can't be played"),
                       message:  String.localized("This podcast can't be played. Sorry! Is it OK if we skip to the next one?"),
                       button:  String.localized("Skip"),
                       handler: { [unowned self] _ in
                        self.removePodcastWithUrl(url, skip: true)
            })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// MARK: Debugging 
    fileprivate func printPodcasts() {
        debugPrint("🔗 PlayerViewController.podcasts:")
        
        for podcast in podcasts {
            debugPrint(podcast.title)
        }
    }

}

extension PlayerViewController : AudioPlayerDelegate {
    func progressDidChange(_ progress: Double) {
        if AudioPlayer.instance.state != Jukebox.State.loading {
            playerView.updateProgress(progress)
        }
    }
    
    func stateDidChange(state: Jukebox.State) {
        
        debugPrint(state.description)
        playerView.updateState(state)
        
    }
}

extension PlayerViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.defaultCellIdentifier, for: indexPath) as? PodcastCollectionViewCell, let podcast = podcasts[safe: (indexPath as NSIndexPath).row] else {
            return UICollectionViewCell()
        }
        
        cell.podcast = podcast
        if let image = UIImage(named: "bg-\(podcast.station)-\(Int(arc4random_uniform(4))+1)") {
            cell.backgroundImageView.image = image
        } else {
            cell.backgroundColor = UIColor.random(0.5)
        }
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
}

extension PlayerViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setCurrentPage()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        setCurrentPage()
    }
}

