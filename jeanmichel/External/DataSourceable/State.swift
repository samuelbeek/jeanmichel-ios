//
//  State.swift
//  DataSourceable
//
//  Created by Niels van Hoorn on 13/10/15.
//  Copyright © 2015 Zeker Waar. All rights reserved.
//

 enum State<D : EmptyCheckable,E> {
    case empty
    case loading(D?)
    case ready(D)
    case error(E,D?)
    
     func toLoading() -> State {
        switch self {
        case .ready(let oldData):
            return .loading(oldData)
        default:
            return .loading(nil)
        }
    }
    
     func toError(_ error:E) -> State {
        switch self {
        case .loading(let oldData):
            return .error(error,oldData)
        default:
            assert(false, "Invalid state transition to .error from other than .Loading")
            return self
        }
    }
    
     func toReady(_ data: D) -> State {
        switch self {
        case .loading:
            if data.isEmpty {
                return .empty
            } else {
                return .ready(data)
            }
        default:
            assert(false, "Invalid state transition to .Ready from other than .Loading")
            return self
        }
    }
    
     var data: D? {
        switch self {
        case .empty:
            return nil
        case .ready(let data):
            return data
        case .loading(let data):
            return data
        case .error(_, let data):
            return data
        }
    }
    
     var error: E? {
        switch self {
        case .error(let error, _):
            return error
        default:
            return nil
        }
    }
}
