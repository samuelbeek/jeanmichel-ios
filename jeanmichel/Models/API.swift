//
//  API.swift
//  jeanmichel
//
//  Created by Samuel Beek on 19/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Result<A> {
    case Error(NSError)
    case Value(A)
}

struct API {
    
    static let baseUrl = "http://localhost:3000"
    
    static func getStations(callback: Result<[Station]> ->()) {
        Alamofire.request(.GET, "\(baseUrl)/station/", encoding: .JSON, parameters: nil).responseJSON { response in
            switch response.result {
                
            case .Success(let data):
                let json = JSON(data)
                var stations = [Station]()
                for (_,subJSON):(String, JSON) in json {
                    guard let title = subJSON["title"].string,
                    let id = subJSON["_id"].string else {
                            debugPrint("object could not be parsed:", subJSON)
                            return
                    }
                    let station = Station(id: id, title: title)
                    stations.append(station)
                }
                callback(.Value(stations))
                break
            case .Failure(let error):
                callback(.Error(error))
            }
        }
    }
    
    static func getPodcasts(station: Station, callback: Result<[Podcast]> ->()) {
        
        
        Alamofire.request(.GET, station.endpoint, encoding: .JSON, parameters: nil).responseJSON {
            response in
            
            switch response.result {
                
            case .Success(let data):
                let json = JSON(data)
                var podcasts = [Podcast]()
                for (_,episode):(String, JSON) in json {
                    guard let title = episode["title"].string,
                        let description = episode["description"].string,
                        let urlString = episode["audioUrl"].string,
                        let url = NSURL(string: urlString) else {
                            debugPrint("object could not be parsed:", episode)
                            return
                    }
                    let podcast = Podcast(title: title, description: description, audioUrl: url)
                    podcasts.append(podcast)
                }
                callback(.Value(podcasts))
                break
            case .Failure(let error):
                callback(.Error(error))
            }
        }

    }
}