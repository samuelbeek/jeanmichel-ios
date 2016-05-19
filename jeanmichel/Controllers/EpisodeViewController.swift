//
//  EpisodeViewController.swift
//  jeanmichel
//
//  Created by Samuel Beek on 20/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit
import Jukebox

class EpisodeViewController : UITableViewController {
    
    var dataSource : UITableViewDataSource!
    let station : Station
    
    init(station: Station) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = station.title
        let source = PodcastDataSource()
        let proxy = TableViewDataSourceProxy(dataSource: source)
        dataSource = proxy
        tableView.dataSource = dataSource
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellIdentifier)
        tableView.reloadData()
        tableView.delegate = self
        
        API.getPodcasts("27%2C11") { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
                
            case .Value(let podcasts):
                source.data = podcasts
                AudioPlayer.instance.setItems(podcasts)
                AudioPlayer.instance.play()
                strongSelf.tableView.reloadData()
                break
            case .Error(let error):
                print(error)
            }
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        AudioPlayer.instance.play(indexPath.row)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

