//
//  DataContaining.swift
//  DataSourceable
//
//  Created by Niels van Hoorn on 13/10/15.
//  Copyright © 2015 Zeker Waar. All rights reserved.
//

 protocol DataContaining {
    associatedtype Data: ElementsContaining
    var data: Data? { get }
    var numberOfItems: Int { get }
    func item(atIndex index: Int) -> Data.Element?
}

 extension DataContaining {
     var numberOfItems: Int {
        return data?.count ?? 0
    }
    
     func item(atIndex index: Int) -> Data.Element? {
        return data?[index]
    }
}