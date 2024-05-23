//
//  MoviesViewReducer.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct MediaViewReducer {

    @ObservableState
    struct State: Equatable {
        var currentSortOrder: MediaSortOrder = .nowPlaying
        var mediaArray: IdentifiedArrayOf<Media> = []
        let mediaType: MediaType
        var path = StackState<DetailsViewReducer.State>()
    }
    
    enum Action {
        case fetchData
        case dataFetched(IdentifiedArrayOf<Media>)
        case sortOrderChanged(MediaSortOrder)
        case path(StackAction<DetailsViewReducer.State, DetailsViewReducer.Action>)
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchData:
                let urlPath = state.currentSortOrder.getURLPath(mediaType: state.mediaType)
                return .run { send in
                    do{
                        let mediaArray = try await apiClient.fetchMediaDetails(urlPath)
                        await send(.dataFetched(mediaArray))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case let .dataFetched(mediaArray):
                state.mediaArray = mediaArray
                return .none
            case let .sortOrderChanged(order):
                guard state.currentSortOrder != order else { return .none }
                state.currentSortOrder = order
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            DetailsViewReducer()
        }
    }
}
