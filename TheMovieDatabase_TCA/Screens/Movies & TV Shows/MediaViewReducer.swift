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
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case fetchData
        case dataFetched(IdentifiedArrayOf<Media>)
        case sortOrderChanged(MediaSortOrder)
        case path(StackAction<DetailsViewReducer.State, DetailsViewReducer.Action>)
        case alert(PresentationAction<Alert>)
        case showAPIErrorAlert(Error)
        enum Alert: Equatable {
        }
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchData:
                let urlPath = Routes.getURLPath(forOrder: state.currentSortOrder, mediaType: state.mediaType)
                return .run { send in
                    do{
                        let mediaArray = try await apiClient.fetchMediaDetails(urlPath + "vbfwhj348257")
                        await send(.dataFetched(mediaArray))
                    } catch {
                        await send(.showAPIErrorAlert(error))
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
            case .alert:
                return .none
            case let .showAPIErrorAlert(error):
                state.alert = .showAPIError(error: error)
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            DetailsViewReducer()
        }
        .ifLet(\.alert, action: \.alert)
    }
}

extension AlertState where Action == MediaViewReducer.Action.Alert {
    static func showAPIError(error: Error) -> Self {
        Self {
            TextState("Error")
        } actions: {
            ButtonState(role: .cancel) {
                TextState("Ok")
            }
        } message: {
            TextState(error.localizedDescription)
        }
    }
}
