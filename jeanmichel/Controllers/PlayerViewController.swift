//
//  EpisodeViewController.swift
//  jeanmichel
//
//  Created by Samuel Beek on 20/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit
import Cartography
import KDEAudioPlayer

class PlayerViewController : UIViewController {
    
    fileprivate let station : Station
    fileprivate var podcasts : [Podcast] = []
    fileprivate var collectionView : UICollectionView!
    fileprivate var playerView : PlayerView!
    fileprivate var currentIndexPath : IndexPath?
    
    init(station: Station) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
        SharedAudioPlayer.instance.delegate = self
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.beginReceivingRemoteControlEvents()

        self.title = station.title
        view.backgroundColor = Styles.Colors.lightPinkColor
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

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
        
        if self.isMovingFromParentViewController {
            SharedAudioPlayer.instance.reset()
            SharedAudioPlayer.instance.delegate = nil
        }
        
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
        SharedAudioPlayer.instance.setItems(self.podcasts)
    }
    
    // MARK: Play and pause
    func playPause() {
        if SharedAudioPlayer.instance.state == .playing {
            pause()
        } else {
            play()
        }
    }
   
    func play(index: Int? = nil) {
        SharedAudioPlayer.instance.play(index)
        playerView.play()
    }
    
    func pause() {
        SharedAudioPlayer.instance.pause()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlayerViewController : SharedAudioPlayerDelegate {
    func shouldSkip(withMessage message: String) {
        self.skip()

        let height : CGFloat = 60
        
        let skipLabel = UILabel(frame: CGRect(x: 0, y: -height, width: view.bounds.width, height: height))
        skipLabel.text = "The podcast wasn't available in your country"
        skipLabel.backgroundColor = .red
        skipLabel.textColor = .white
        skipLabel.font = UIFont.systemFont(ofSize: 12)
        skipLabel.textAlignment = .center
        UIApplication.shared.keyWindow?.addSubview(skipLabel)
    
        UIView.animate(withDuration: 0.3, animations: {
            skipLabel.frame.origin.y = 0
            }, completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 2, options: .curveEaseIn, animations: {
            skipLabel.frame.origin.y = -height
                    }, completion: { _ in
                skipLabel.removeFromSuperview()
                })
        })
        
    }
    
    func progressDidChange(_ progress: Double) {
        if SharedAudioPlayer.instance.state != AudioPlayerState.buffering {
            playerView.updateProgress(progress)
        }
    }
    
    func stateDidChange(state: AudioPlayerState) {
        debugPrint(state)
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
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == .remoteControl {
            switch event!.subtype {
            case .remoteControlPlay :
                self.play()
            case .remoteControlPause :
                self.pause()
            case .remoteControlNextTrack :
                self.skip()
            case .remoteControlPreviousTrack:
                self.previous()
            case .remoteControlTogglePlayPause:
                if SharedAudioPlayer.instance.state == .playing {
                    self.pause()
                } else {
                    self.play()
                }
            default:
                break
            }
        }
    }

}

extension PlayerViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.async(execute: { _ in
            self.setCurrentPage()
        })
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        DispatchQueue.main.async(execute: { _ in
            self.setCurrentPage()
        })
    }
}


