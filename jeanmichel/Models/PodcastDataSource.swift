//
//  PodcastDataSource.swift
//  jeanmichel
//
//  Created by Samuel Beek on 19/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit

class PodcastDataSource: CollectionViewDataSourceable, DataContaining {
    typealias Data = [Podcast]
    typealias Section = Data
    var data: Data?
    
    func reuseIdentifier(forIndexPath indexPath: NSIndexPath) -> String {
        return Constants.defaultCellIdentifier
    }
    
    func configure(cell cell: UICollectionViewCell,  forItem item: Podcast, inView view: UICollectionView) -> UICollectionViewCell {
        if let cell = cell as? PodcastCollectionViewCell {
            cell.podcast = item
            cell.contentView.backgroundColor = UIColor.randomColor(1)
        }
        return cell
    }
}
