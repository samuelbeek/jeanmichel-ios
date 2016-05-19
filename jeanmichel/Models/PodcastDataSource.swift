//
//  PodcastDataSource.swift
//  jeanmichel
//
//  Created by Samuel Beek on 19/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit

class PodcastDataSource: TableViewDataSourceable, DataContaining {
    typealias Data = [String]
    typealias Section = Data
    var data: Data? = ["Science","Art","Design","Interviewss"]
    
    func reuseIdentifier(forIndexPath indexPath: NSIndexPath) -> String {
        return Constants.defaultCellIdentifier
    }
    
    func configure(cell cell: UITableViewCell, forItem item: String, inView view: UITableView) -> UITableViewCell {
        cell.textLabel?.text = item
        return cell
    }
}
