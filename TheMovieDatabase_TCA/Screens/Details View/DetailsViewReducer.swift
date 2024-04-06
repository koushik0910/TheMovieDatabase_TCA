//
//  DetailsView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 05/04/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DetailsViewReducer {
    
    @ObservableState
    struct State: Equatable {
        let movie: Movie
        var cast: [Cast]?
    }
    
    enum Action {
        case fetchCastDetails
        case castDetailsFetched([Cast]?)
        case delegate(Delegate)
        case favouriteButtonTapped
        
        enum Delegate: Equatable {
            case addOrRemoveFavourites(Movie)
        }
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchCastDetails:
                return .run { [movieId = state.movie.id] send in
                    let result = try await apiClient.fetchCastDetails(movieId)
                    await send(.castDetailsFetched(result))
                }
            case let .castDetailsFetched(cast):
                state.cast = cast
                return .none
            case .delegate(_):
                return .none
            case .favouriteButtonTapped:
                return .run { [movie = state.movie] send in
                    await send(.delegate(.addOrRemoveFavourites(movie)))
                }
            }
        }
    }
}
