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
        let proxy = TableViewDataSourceProxy(dataSource: PodcastDataSource())
        dataSource = proxy
        tableView.dataSource = dataSource
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellIdentifier)
        tableView.reloadData()
        self.title = "stations"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
