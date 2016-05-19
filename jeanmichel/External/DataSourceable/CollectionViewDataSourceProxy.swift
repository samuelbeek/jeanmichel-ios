//
//  CollectionViewDataSourceProxy.swift
//  DataSourceable
//
//  Created by Niels van Hoorn on 29/12/15.
//  Copyright © 2015 Zeker Waar. All rights reserved.
//
import UIKit

 class CollectionViewDataSourceProxy: NSObject, UICollectionViewDataSource {
     let dataSource: CollectionViewDataSource
    
     init(dataSource: CollectionViewDataSource) {
        self.dataSource = dataSource
    }
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return dataSource.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
    }
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSectionsInCollectionView(collectionView)
    }

     func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return dataSource.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }
     func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return dataSource.collectionView(collectionView, canMoveItemAtIndexPath: indexPath)
    }
     func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        return dataSource.collectionView(collectionView, moveItemAtIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
    }
}
