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
    }
    
    enum Action {
        case fetchCastAndReviewDetails
        case castAndReviewDetailsFetched([Cast]?, [Review]?)
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
                return .run { [movieId = state.movie.id] send in
                    async let castDetails = apiClient.fetchCastDetails(movieId)
                    async let reviews = apiClient.fetchReviews(movieId)
                    await send(.castAndReviewDetailsFetched(try castDetails, try reviews))
                }
            case let .castAndReviewDetailsFetched(cast, reviews):
                state.cast = cast
                state.reviews = reviews
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
