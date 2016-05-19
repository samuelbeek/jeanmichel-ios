//
//  TableViewDataSourceProxy.swift
//  DataSourceable
//
//  Created by Niels van Hoorn on 29/12/15.
//  Copyright © 2015 Zeker Waar. All rights reserved.
//
import UIKit

class TableViewDataSourceProxy: NSObject, UITableViewDataSource {
     let dataSource: TableViewDataSource
    
     init(dataSource: TableViewDataSource) {
        self.dataSource = dataSource
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.tableView(tableView, numberOfRowsInSection: section)
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return dataSource.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.numberOfSectionsInTableView(tableView)
    }
    
     func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource.tableView(tableView, titleForHeaderInSection: section)
    }
    
     func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return dataSource.tableView(tableView, titleForFooterInSection: section)
    }
}