//
//  BrowseTableViewController.swift
//  jeanmichel
//
//  Created by Samuel Beek on 19/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit

class StationTableViewController : UITableViewController {
    
    var dataSource : TableViewDataSourceProxy!
    var stations = [Station(title: "science", endpoint: "27%2C11"), Station(title: "stories", endpoint: "27%2C11"), Station(title: "internet", endpoint: "27%2C11"), Station(title: "design", endpoint: "27%2C11")]
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        self.title = "stations"

        super.viewDidLoad()
        let source = StationDataSource()
        source.data = stations
        let proxy = TableViewDataSourceProxy(dataSource: source)
        dataSource = proxy
        tableView.dataSource = dataSource
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellIdentifier)
        tableView.reloadData()
        tableView.delegate = self
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let station = stations[safe: indexPath.row] else {
             return
        }
        self.navigationController?.pushViewController(EpisodeViewController(station: station), animated: true)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
