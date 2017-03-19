//
//  ArtistApi.swift
//  SpotifyTest
//
//  Created by Jesus Garcia on 3/17/17.
//  Copyright © 2017 Jesus Garcia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArtistApi {
    
    static let sharedInstance:ArtistApi = ArtistApi()
    
    private init() {}
    
    func getArtisit(query:String,_ completion: @escaping ( _ artists: [Artist]? ) -> () ) -> Void  {
        
        let params: jsonDictionary = ["q": query, "type": "artist"]    
        
        var artits = [Artist]()
        
        Alamofire.request(Router.searchArtists(parameters: params))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    let artistJson = JSON(json)["artists"]["items"]
                    for (_,subJson):(String, JSON) in artistJson {
                        let artistId = subJson["id"].string!
                        let artistName = subJson["name"].string!
                        let artistPopularity = subJson["popularity"].int!
                        let artistFollowers = subJson["followers"]["total"].int!
                        let artistImage = subJson["images"][0]["url"].string
                        
                        let newArtist = Artist(id: artistId, name: artistName, image: artistImage, popularity: artistPopularity, followers: artistFollowers)
                        
                        artits.append(newArtist!)
                    }
                    completion(artits)
                    
                case .failure( _):
                    completion(nil)
                }
        }
    }
    
}
