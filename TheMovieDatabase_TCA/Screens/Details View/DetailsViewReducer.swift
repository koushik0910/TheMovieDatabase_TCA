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
        var reviews: [Review]?
        var isFavourite: Bool
    }
    
    enum Action {
        case fetchCastAndReviewDetails
        case castDetailsFetched([Cast]?)
        case reviewsFetched([Review]?)
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
            case .fetchCastAndReviewDetails:
                return .merge(
                    .run { [movieId = state.movie.id] send in
                        let castDetails = await apiClient.fetchCastDetails(movieId)
                        await send(.castDetailsFetched(castDetails))
                    }
                    , .run { [movieId = state.movie.id] send in
                        let reviews = await apiClient.fetchReviews(movieId)
                        await send(.reviewsFetched(reviews))
                    }
                )
            case let .castDetailsFetched(cast):
                state.cast = cast
                return .none
            case let .reviewsFetched(reviews):
                state.reviews = reviews
                return .none
            case .delegate(_):
                return .none
            case .favouriteButtonTapped:
                state.isFavourite.toggle()
                return .run { [movie = state.movie] send in
                    await send(.delegate(.addOrRemoveFavourites(movie)))
                }
            }
        }
    }
}
