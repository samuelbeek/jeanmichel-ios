//
//  TableViewDataSource.swift
//  DataSourceable
//
//  Created by Niels van Hoorn on 29/12/15.
//  Copyright © 2015 Zeker Waar. All rights reserved.
//
import UIKit

 protocol TableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
}

 extension TableViewDataSource {
     func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
     func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
}

 extension TableViewDataSource where Self: Sectionable {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }
    
     func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return numberOfSections
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader(atIndex: section)
    }

     func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sectionFooter(atIndex: section)
    }
}

 extension TableViewDataSource where Self: Sectionable, Self.ItemType == Self.Section.Data.Element, Self: CellProviding, Self.CellType == UITableViewCell, Self.ViewType == UITableView {
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let identifier = reuseIdentifier(forIndexPath: indexPath)
        guard let itemAtIndexPath = item(atIndexPath: indexPath) else {
            return tableView.dequeueReusableCell(withIdentifier: identifier)!
        }
        let cell: CellType = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        configure(cell: cell, forItem: itemAtIndexPath, inView: tableView)
        return cell
    }
}
