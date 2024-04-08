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
        let isMovie: Bool
        var path = StackState<DetailsViewReducer.State>()
        var favourites = Favourites()
    }
    
    enum Action {
        case fetchData
        case dataFetched([Movie])
        case sortOrderChanged(SortOrder)
        case path(StackAction<DetailsViewReducer.State, DetailsViewReducer.Action>)
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchData:
                let urlString = state.currentSortOrder.getURLString(isMovie: state.isMovie)
                return .run { send in
                    do{
                        let movies = try await apiClient.fetchMovies(urlString)
                        await send(.dataFetched(movies))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case let .dataFetched(movies):
                state.movies = movies
                return .none
            case let .sortOrderChanged(order):
                guard state.currentSortOrder != order else { return .none }
                state.currentSortOrder = order
                return .none
            case .path(.element(id: _, action: .delegate(.addOrRemoveFavourites(let movie)))):
                state.favourites.addOrRemoveMovies(movie)
                return .none
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            DetailsViewReducer()
        }
    }
}
