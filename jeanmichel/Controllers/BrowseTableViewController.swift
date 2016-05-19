//
//  BrowseTableViewController.swift
//  jeanmichel
//
//  Created by Samuel Beek on 19/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit

class BrowseTableViewController : UITableViewController {
    
    var dataSource : UITableViewDataSource!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let source = PodcastDataSource()
        let proxy = TableViewDataSourceProxy(dataSource: source)
        dataSource = proxy
        tableView.dataSource = dataSource
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellIdentifier)
        tableView.reloadData()
        self.title = "stations"
        
        API.getPodcasts() { result in
            debugPrint(result)
            
            switch result {
            case .Value(let podcasts):
                source.data = podcasts
                self.tableView.reloadData()
                break
            case .Error(let error):
                debugPrint(error)
            }
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
