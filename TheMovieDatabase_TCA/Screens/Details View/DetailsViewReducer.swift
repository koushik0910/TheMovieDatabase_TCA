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
        var casts: [Cast]?
    }
    
    enum Action {
        case fetchCastDetails
        case castDetailsFetched([Cast]?)
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
            case let .castDetailsFetched(casts):
                state.casts = casts
                return .none
            case .favouriteTapped:
                return .none
            }
        }
    }
}
