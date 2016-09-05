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
            if let image = UIImage(named: "bg-\(item.station)-0\(Int(arc4random_uniform(4))+1)") {
                cell.backgroundImageView.image = image
            } else {
                cell.backgroundColor = UIColor.randomColor(0.5)
            }
        }
        return cell
    }
}
