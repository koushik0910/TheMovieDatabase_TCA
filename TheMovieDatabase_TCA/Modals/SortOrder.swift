//
//  SortOrder.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import Foundation

enum MovieType {
    case movie
    case tvShow
}

enum SortOrder: String, CaseIterable {
    case nowPlaying = "Now Playing"
    case popular = "Popular"
    case topRated = "Top Rated"
    
    func getURLPath(movieType: MovieType) ->  String {
        switch self {
        case .nowPlaying:
            switch movieType {
            case .movie:
                return "/3/movie/now_playing"
            case .tvShow:
                return "/3/tv/on_the_air"
            }
        case .popular:
            switch movieType {
            case .movie:
                return "/3/movie/popular"
            case .tvShow:
                return "/3/tv/popular"
            }
        case .topRated:
            switch movieType {
            case .movie:
                return "/3/movie/top_rated"
            case .tvShow:
                return "/3/tv/top_rated"
            }
        }
    }
}
