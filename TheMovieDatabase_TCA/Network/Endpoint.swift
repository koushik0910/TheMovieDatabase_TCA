//
//  URLEndpoint.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 16/05/24.
//

import Foundation

struct EndPoint {
    var urlPath: String
    var params: [String: String]
}

extension EndPoint {
    var url: URL? {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.themoviedb.org"
        urlComponent.path = urlPath
        urlComponent.queryItems = params.map {
           URLQueryItem(name: $0.0, value: $0.1 )
        }
        return urlComponent.url
    }
}
