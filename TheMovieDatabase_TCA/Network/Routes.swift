//
//  Routes.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 22/05/24.
//

import Foundation

enum Routes {
    case search
    case cast(Int)
    case reviews(Int)
    case trending(MediaType)
    case nowPlaying(MediaType)
    case popular(MediaType)
    case topRated(MediaType)
    case completeImageURLString(String)
    
    var path: String {
        switch self {
        case .search:
            "/3/search/movie"
            
        case .cast(let mediaId):
            "/3/movie/\(mediaId)/credits"
            
        case .reviews(let mediaId):
            "/3/movie/\(mediaId)/reviews"
            
        case .trending(let mediaType):
            "/3/trending/\(mediaType.rawValue)/day"
            
        case .nowPlaying(let mediaType):
            switch mediaType{
            case .movie:
                "/3/movie/now_playing"
            case .tv:
                "/3/tv/on_the_air"
            }
            
        case .popular(let mediaType):
            "/3/\(mediaType.rawValue)/popular"
            
        case .topRated(let mediaType):
            "/3/\(mediaType.rawValue)/top_rated"
            
        case .completeImageURLString(let path):
            "https://image.tmdb.org/t/p/w500\(path)"
        }
    }
    
    static func getURLPath(forSection section: HomeSection) -> String {
        switch section {
        case .trending:
            return Routes.trending(.movie).path
        case .popular:
            return Routes.popular(.movie).path
        case .tvShows:
            return Routes.nowPlaying(.tv).path
        }
    }
    
    static func getURLPath(forOrder order: MediaSortOrder, mediaType: MediaType) -> String {
        switch order {
        case .nowPlaying:
            Routes.nowPlaying(mediaType).path
        case .popular:
            Routes.popular(mediaType).path
        case .topRated:
            Routes.topRated(mediaType).path
        }
    }
}
