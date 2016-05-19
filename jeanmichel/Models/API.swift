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
    
    static func getPodcasts(endpoint: String, callback: Result<[Podcast]> ->()) {
        Alamofire.request(.GET, "\(baseUrl)/audiosearch/shows/episodes?shows=\(endpoint)", encoding: .JSON, parameters: nil).responseJSON {
            response in
            
            switch response.result {
                
            case .Success(let data):
                let json = JSON(data)
                var podcasts = [Podcast]()
                for (_,episode):(String, JSON) in json {
                    guard let title = episode["title"].string,
                        let description = episode["description"].string,
                        let audioFiles = episode["audio_files"].array,
                        let urlArray = audioFiles[0]["url"].array,
                        let urlString = urlArray[0].string,
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
                print(error)
                callback(.Error(error))
            }
        }

    }
}