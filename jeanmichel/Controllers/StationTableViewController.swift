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
    var stations : [Station]  = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        self.title = "stations"

        super.viewDidLoad()
        let source = StationDataSource()
        let proxy = TableViewDataSourceProxy(dataSource: source)
        dataSource = proxy
        tableView.dataSource = dataSource
        tableView.registerClass(ChannelTableViewCell.self, forCellReuseIdentifier: Constants.defaultCellIdentifier)
        tableView.reloadData()
        tableView.delegate = self
        
        // NavigationController Styling
        navigationController?.navigationBar.barTintColor = Styles.Colors.stationHeaderBackgroundColor
        navigationController?.navigationBar.tintColor = .whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: Styles.headerFont, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
    
        
        // bind data
        API.getStations() { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .Value(let stations):
                strongSelf.stations = stations
                source.data = stations
                strongSelf.tableView.reloadData()
            case .Error(let error):
                print(error.debugDescription)
            }
            
        }
}
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let station = stations[safe: indexPath.row] else {
             return
        }
        self.navigationController?.pushViewController(PlayerViewController(station: station), animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Styles.stationCellHeight
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
