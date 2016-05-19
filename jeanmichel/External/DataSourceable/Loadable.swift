//
//  LoadableDataSource.swift
//  DataSourceable
//
//  Created by Niels van Hoorn on 13/10/15.
//  Copyright © 2015 Zeker Waar. All rights reserved.
//

 protocol Loadable: class {
    associatedtype Data : EmptyCheckable
    var state: State<Data,ErrorType> { get set }
    func loadData(completion: (Data) -> Void) throws
}

 extension Loadable {
    func reload(completion: () -> Void) {
        state = state.toLoading()
        do {
            try loadData { data in
                self.state = self.state.toReady(data)
                completion()
            }
        } catch {
            self.state = self.state.toError(error)
            completion()
        }
    }
    
    var data: Data? {
        return state.data
    }
}
