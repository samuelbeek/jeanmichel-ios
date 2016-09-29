//
//  CellProviding.swift
//  DataSourceable
//
//  Created by Niels van Hoorn on 29/12/15.
//  Copyright © 2015 Zeker Waar. All rights reserved.
//

import UIKit

protocol CellProviding {
    associatedtype ItemType
    associatedtype CellType
    associatedtype ViewType
    func reuseIdentifier(forIndexPath indexPath: IndexPath) -> String
    func configure(cell: CellType, forItem item: ItemType, inView view: ViewType) -> CellType
}
