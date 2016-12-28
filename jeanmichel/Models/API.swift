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
    case error(NSError)
    case value(A)
}

struct API {
    
    static let baseUrl = Constants.production ? "http://jeanmichel-backend.herokuapp.com" : "http://localhost:3000"
    
    static func getStations(_ callback: @escaping (Result<[Station]>) ->()) {
        
        Alamofire.request("\(baseUrl)/station/").responseJSON { response in
            switch response.result {
                
            case .success(let data):
                let json = JSON(data)
                var stations = [Station]()
                for (_,subJSON):(String, JSON) in json {
                    guard let title = subJSON["title"].string,
                    let id = subJSON["_id"].string else {
                            printError(100, message: "object could not be parsed: \(subJSON)")
                            return
                    }
                    let station = Station(id: id, title: title)
                    stations.append(station)
                }
                stations = stations.sorted() { first, last in
                    return first.title < last.title
                }
                callback(.value(stations))
                break
            case .failure(let error):
                callback(.error(error as NSError))
            }
        }
    }
    
    static func getPodcasts(_ station: Station, callback: @escaping (Result<[Podcast]>) ->()) {
        
        Alamofire.request(station.endpoint).responseJSON {
            response in
            
            switch response.result {
                
            case .success(let data):
                let json = JSON(data)
                var podcasts = [Podcast]()
                for (_,episode):(String, JSON) in json {
                    guard let titleString = episode["title"].string,
                        let description = episode["description"].string,
                        let urlString = episode["audioUrl"].string,
                        let showTitle = episode["_creator"]["title"].string,
                        let duration = episode["duration"].double,
                        let url = NSURL(string: urlString) else {
                            printError(100, message: "object could not be parsed: \(episode)")
                            return
                    }
                    
                    let title = titleString.replacingOccurrences(of: showTitle, with:"")
                    
                    let podcast = Podcast(title: title, showTitle: showTitle, description: description, audioUrl: url as URL, duration: duration, station: station.title.lowercased())
                    podcasts.append(podcast)
                }
                callback(.value(podcasts))
                break
            case .failure(let error):
                callback(.error(error as NSError))
            }
        }

    }
}
