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
        let media: Media
        var cast: IdentifiedArrayOf<Cast>?
        var reviews: IdentifiedArrayOf<Review>?
        @Shared(.userFavourites) var userFavourites: IdentifiedArrayOf<Media> = []
    }
    
    enum Action {
        case fetchCastAndReviewDetails
        case castDetailsFetched(IdentifiedArrayOf<Cast>?)
        case reviewsFetched(IdentifiedArrayOf<Review>?)
        case favouriteButtonTapped
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchCastAndReviewDetails:
                return .merge(
                    .run { [mediaId = state.media.id] send in
                        let castDetails = try? await apiClient.fetchCastDetails(mediaId)
                        await send(.castDetailsFetched(castDetails))
                    }
                    , .run { [mediaId = state.media.id] send in
                        let reviews = try? await apiClient.fetchReviews(mediaId)
                        await send(.reviewsFetched(reviews))
                    }
                )
            case let .castDetailsFetched(cast):
                state.cast = cast
                return .none
            case let .reviewsFetched(reviews):
                state.reviews = reviews
                return .none
            case .favouriteButtonTapped:
                if !state.userFavourites.insert(state.media, at: 0).inserted {
                    state.userFavourites.remove(state.media)
                }
                return .none
            }
        }
    }
}

