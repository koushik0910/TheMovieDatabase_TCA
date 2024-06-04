//
//  SectionData.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import Foundation
import ComposableArchitecture

struct HomeSectionData: Identifiable, Equatable {
    let id: HomeSections
    let title: String
    let data: IdentifiedArrayOf<Media>?
}

enum HomeSections: Int, CaseIterable {
    case trending = 0
    case popular
    case tvShows

    
    var title: String {
        switch self {
        case .trending:
            return "Trending"
        case .popular:
            return "What's Popular"
        case .tvShows:
            return "TV Shows"
        }
    }
    
    var path: String {
        switch self {
        case .trending:
            return Routes.trending(.movie).path
        case .popular:
            return Routes.popular(.movie).path
        case .tvShows:
            return Routes.nowPlaying(.tv).path
        }
    }
}
