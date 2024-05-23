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
    static func createURL(urlPath: String, params: [String: String]? = nil) -> EndPoint {
        if var params {
            params[Constants.ParamKeys.apiKey]  = Constants.ParamValues.apiKey
            return EndPoint(urlPath: urlPath, params: params)
        }
        return EndPoint(urlPath: urlPath, params: [Constants.ParamKeys.apiKey: Constants.ParamValues.apiKey])
    }
}

extension EndPoint {
    var url: URL {
        get throws {
            var urlComponent = URLComponents()
            urlComponent.scheme = "https"
            urlComponent.host = "api.themoviedb.org"
            urlComponent.path = urlPath
            urlComponent.queryItems = params.map {
               URLQueryItem(name: $0.0, value: $0.1 )
            }
            guard let url = urlComponent.url else { throw URLError(.badURL) }
            return url
        }
    }
}
