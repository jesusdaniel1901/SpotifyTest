//
//  AlbumApi.swift
//  SpotifyTest
//
//  Created by Jesus Garcia on 3/18/17.
//  Copyright © 2017 Jesus Garcia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AlbumApi {
    
    static let sharedInstance:AlbumApi = AlbumApi()
    
    private init() {}
    
    func getAlbum(artistId:String,_ completion: @escaping ( _ albums: [Album]? ) -> () ) -> Void  {
        
        var albums = [Album]()
        
        Alamofire.request(Router.getArtistAlbums(artistId: artistId))
            .validate()
            .responseJSON { response in                
                switch response.result {
                case .success(let json):
                    let artistJson = JSON(json)["items"]
                    for (_,subJson):(String, JSON) in artistJson {
                        let albumName = subJson["name"].string!
                        let albumImage = subJson["images"][0]["url"].string
                        let albumUrl = subJson["external_urls"]["spotify"].string!
                        let newAlbum = Album(name: albumName, image: albumImage,url: albumUrl)
                        
                        albums.append(newAlbum!)
                    }
                    completion(albums)
                    
                case .failure:
                    completion(nil)
                }
        }
    }
    
}
