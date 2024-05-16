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

    var path: String {
        switch self {
        case .trending:
            return "/3/trending/movie/day"
        case .popular:
            return "/3/movie/popular"
        case .tvShows:
            return "/3/tv/popular"
        }
    }
}
