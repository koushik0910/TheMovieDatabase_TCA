//
//  Section.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import Foundation

enum Section:String, CaseIterable {
    case trending = "Trending"
    case popular = "What's Popular"
    case tvShows = "TV Shows"

    var urlString: String {
        switch self {
        case .trending:
            return "https://api.themoviedb.org/3/trending/movie/day?api_key=909594533c98883408adef5d56143539"
        case .popular:
            return "https://api.themoviedb.org/3/movie/popular?api_key=909594533c98883408adef5d56143539"
        case .tvShows:
            return "https://api.themoviedb.org/3/tv/popular?api_key=909594533c98883408adef5d56143539"
        }
    }
}
