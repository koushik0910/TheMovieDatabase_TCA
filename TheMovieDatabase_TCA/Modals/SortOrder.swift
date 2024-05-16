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
    
    func getURLString(movieType: MovieType) ->  String {
        switch self {
        case .nowPlaying:
            switch movieType {
            case .movie:
                return "https://api.themoviedb.org/3/movie/now_playing?api_key=909594533c98883408adef5d56143539"
            case .tvShow:
                return "https://api.themoviedb.org/3/tv/on_the_air?api_key=909594533c98883408adef5d56143539"
            }
        case .popular:
            switch movieType {
            case .movie:
                return "https://api.themoviedb.org/3/movie/popular?api_key=909594533c98883408adef5d56143539"
            case .tvShow:
                return "https://api.themoviedb.org/3/tv/popular?api_key=909594533c98883408adef5d56143539"
            }
        case .topRated:
            switch movieType {
            case .movie:
                return "https://api.themoviedb.org/3/movie/top_rated?api_key=909594533c98883408adef5d56143539"
            case .tvShow:
                return "https://api.themoviedb.org/3/tv/top_rated?api_key=909594533c98883408adef5d56143539"
            }
        }
    }
}
