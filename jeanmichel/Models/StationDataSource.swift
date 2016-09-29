//
//  StationDataSource.swift
//  jeanmichel
//
//  Created by Samuel Beek on 20/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit

class StationDataSource: TableViewDataSourceable, DataContaining {
    typealias Data = [Station]
    typealias Section = Data
    var data: Data?
    
    func reuseIdentifier(forIndexPath indexPath: IndexPath) -> String {
        return Constants.defaultCellIdentifier
    }
    
    func configure(cell: UITableViewCell, forItem item: Station, inView view: UITableView) -> UITableViewCell {
        cell.textLabel?.text = item.title.lowercased()
        return cell
    }
}
