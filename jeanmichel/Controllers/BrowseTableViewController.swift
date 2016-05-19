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
        let proxy = TableViewDataSourceProxy(dataSource: MovieTitleDataSource())
        dataSource = proxy
        tableView.dataSource = dataSource
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellIdentifier)
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MovieTitleDataSource: TableViewDataSourceable, DataContaining {
    typealias Data = [String]
    typealias Section = Data
    var data: Data? = ["Casino Royale","Quantum of Solace","Skyfall","Spectre"]
    
    func reuseIdentifier(forIndexPath indexPath: NSIndexPath) -> String {
        return Constants.defaultCellIdentifier
    }
    
    func configure(cell cell: UITableViewCell, forItem item: String, inView view: UITableView) -> UITableViewCell {
        cell.textLabel?.text = item
        return cell
    }
}
