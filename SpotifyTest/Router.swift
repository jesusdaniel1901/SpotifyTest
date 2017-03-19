
//
//  Router.swift
//  SpotifyTest
//
//  Created by Jesus Garcia on 3/17/17.
//  Copyright © 2017 Jesus Garcia. All rights reserved.
//

import Foundation
import Alamofire
typealias jsonDictionary = [String: Any]

enum Router {
    
    // MARK: - Configuration
    private static let baseHostPath = "https://api.spotify.com"
    private static let versionPath = "/v1"
    
    
    
    var baseURLPath: String {
        return "\(Router.baseHostPath)\(Router.versionPath)"
    }
    
    case searchArtists(parameters: jsonDictionary)
    case getArtistAlbums(artistId: String)
    
}

extension Router {
    
    typealias HTTPMethod = Alamofire.HTTPMethod
    
    struct Request {
        let method: HTTPMethod
        let path: String
        let encoding: ParameterEncoding
        let parameters: jsonDictionary?
        
        init(method: HTTPMethod, path: String, parameters: jsonDictionary? = nil, encoding: ParameterEncoding = JSONEncoding.default) {
            self.method = method
            self.path = path
            self.encoding = encoding
            self.parameters = parameters
        }
    }
    
    var request: Request {
        switch self {
            
        case .searchArtists(let params):
            return Request(method: .get, path: "/search",parameters: params,encoding: URLEncoding.default)
            
        case .getArtistAlbums(let artistId):
            return Request(method: .get, path: "/artists/\(artistId)/albums")
            
        }
    }
}

extension Router: URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURLPath)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(request.path))
        urlRequest.httpMethod = request.method.rawValue      
        
        return try request.encoding.encode(urlRequest, with: request.parameters)
    }
}

