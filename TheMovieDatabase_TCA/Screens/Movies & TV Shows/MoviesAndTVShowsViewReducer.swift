//
//  MoviesViewReducer.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct MoviesAndTVShowsViewReducer {
    @ObservableState
    struct State: Equatable {
        var currentSortOrder: SortOrder = .nowPlaying
        var movies: [Movie] = []
        var isMovie: Bool
    }
    
    enum Action {
        case fetchData
        case dataFetched([Movie])
        case sortOrderChanged(SortOrder)
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchData:
                let urlString = state.currentSortOrder.getURLString(isMovie: state.isMovie)
                return .run { send in
                    let movies = try await apiClient.fetchMovies(urlString)
                    await send(.dataFetched(movies))
                }
            case let .dataFetched(movies):
                state.movies = movies
                return .none
            case let .sortOrderChanged(order):
                guard state.currentSortOrder != order else { return .none }
                state.currentSortOrder = order
                return .none
            }
        }
    }
}
