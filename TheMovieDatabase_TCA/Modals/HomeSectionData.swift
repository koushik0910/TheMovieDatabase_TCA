//
//  SectionData.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import Foundation
import ComposableArchitecture

struct HomeSectionData: Identifiable, Equatable {
    let id: HomeSection
    let title: String
    var data: IdentifiedArrayOf<Media>?
}

enum HomeSection: Int, CaseIterable {
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
}
