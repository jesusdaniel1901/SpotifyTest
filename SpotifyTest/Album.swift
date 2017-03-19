//
//  Album.swift
//  SpotifyTest
//
//  Created by Jesus Garcia on 3/18/17.
//  Copyright © 2017 Jesus Garcia. All rights reserved.
//

import UIKit

class Album {
    
    var name:String
    var image:String?
    var url:String
    
    
    init?(name:String,image:String?,url:String) {
        self.name = name
        self.image = image
        self.url = url
    }   
    

}
