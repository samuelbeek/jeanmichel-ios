//
//  EmptyCheckable.swift
//  DataSourceable
//
//  Created by Niels van Hoorn on 13/10/15.
//  Copyright © 2015 Zeker Waar. All rights reserved.
//

protocol EmptyCheckable {
    var isEmpty: Bool { get }
}

extension Array : EmptyCheckable {}
