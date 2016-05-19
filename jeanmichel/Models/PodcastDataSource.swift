//
//  PodcastDataSource.swift
//  jeanmichel
//
//  Created by Samuel Beek on 19/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit

class PodcastDataSource: TableViewDataSourceable, DataContaining {
    typealias Data = [Podcast]
    typealias Section = Data
    var data: Data?
    
    func reuseIdentifier(forIndexPath indexPath: NSIndexPath) -> String {
        return Constants.defaultCellIdentifier
    }
    
    func configure(cell cell: UITableViewCell, forItem item: Podcast, inView view: UITableView) -> UITableViewCell {
        cell.textLabel?.text = item.title
        return cell
    }
}
