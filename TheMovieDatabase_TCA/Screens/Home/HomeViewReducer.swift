//
//  HomeViewReducer.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct HomeViewReducer {

    @ObservableState
    struct State: Equatable {
        var sections : IdentifiedArrayOf<HomeSectionData> = []
        var searchQuery = ""
        var searchedResults: IdentifiedArrayOf<Media> = []
        var path = StackState<DetailsViewReducer.State>()
    }
    
    enum Action {
        case fetchData
        case dataFetched((HomeSections, IdentifiedArrayOf<Media>?))
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchResultFetched(IdentifiedArrayOf<Media>)
        case path(StackAction<DetailsViewReducer.State, DetailsViewReducer.Action>)
    }
    
    private enum CancelID { case search }
    @Dependency(\.apiClient) var apiClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchData:
                guard state.sections.count != HomeSections.allCases.count else { return .none }
                return .merge (
                    .run { send in
                        let mediaDetails = try? await apiClient.fetchMediaDetails(HomeSections.trending.path)
                        await send(.dataFetched((.trending, mediaDetails)))
                    },
                    .run { send in
                        let mediaDetails = try? await apiClient.fetchMediaDetails(HomeSections.popular.path)
                        await send(.dataFetched((.popular, mediaDetails)))
                    },
                    .run { send in
                        let mediaDetails = try? await apiClient.fetchMediaDetails(HomeSections.tvShows.path)
                        await send(.dataFetched((.tvShows, mediaDetails)))
                    }
                )
            case let .dataFetched(data):
                state.sections.append(HomeSectionData(id: data.0, title: data.0.rawValue, data: data.1))
                return .none
            case let .searchQueryChanged(query):
                state.searchQuery = query
                guard !state.searchQuery.isEmpty else {
                    state.searchedResults = []
                    return .cancel(id: CancelID.search)
                }
                return .none
            case .searchQueryChangeDebounced:
                guard !state.searchQuery.isEmpty else { return .none }
                return .run { [query = state.searchQuery] send in
                    do{
                        let result = try await apiClient.searchMovies(query)
                        await send(.searchResultFetched(result))
                    }catch{
                        print(error.localizedDescription)
                    }
                }
                .cancellable(id: CancelID.search)
            case let .searchResultFetched(movies):
                state.searchedResults = movies
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
