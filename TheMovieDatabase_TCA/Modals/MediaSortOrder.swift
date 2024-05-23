//
//  MediaSortOrder.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import Foundation

enum MediaType: String {
    case movie
    case tv
}

enum MediaSortOrder: String, CaseIterable {
    case nowPlaying = "Now Playing"
    case popular = "Popular"
    case topRated = "Top Rated"
    
    func getURLPath(mediaType: MediaType) ->  String {
        switch self {
        case .nowPlaying:
            Routes.nowPlaying(mediaType).path
        case .popular:
            Routes.popular(mediaType).path
        case .topRated:
            Routes.topRated(mediaType).path
        }
    }
}
