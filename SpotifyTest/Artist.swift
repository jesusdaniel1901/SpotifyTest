//
//  Artist.swift
//  SpotifyTest
//
//  Created by Jesus Garcia on 3/16/17.
//  Copyright © 2017 Jesus Garcia. All rights reserved.
//

import UIKit

class Artist {
    
    var id:String
    var name:String
    var image:String?
    var popularity:Int
    var followers:Int
    
    
    init?(id:String,name:String,image:String?,popularity:Int,followers:Int) {
        self.id = id
        self.name = name
        self.image = image
        self.popularity = popularity
        self.followers = followers
    }
    
        
    
}
