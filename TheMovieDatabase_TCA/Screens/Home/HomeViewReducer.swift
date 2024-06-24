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
        var sections : IdentifiedArrayOf<HomeSectionData> = IdentifiedArrayOf(
            uniqueElements: HomeSection.allCases.map {
                HomeSectionData(id: $0, title: $0.title, data: [])
            })
        var searchQuery = ""
        var searchedResults: IdentifiedArrayOf<Media> = []
        var path = StackState<DetailsViewReducer.State>()
    }
    
    enum Action {
        case fetchData
        case dataFetched(HomeSection, IdentifiedArrayOf<Media>?)
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchResultFetched(Result<IdentifiedArrayOf<Media>, Error>)
        case path(StackAction<DetailsViewReducer.State, DetailsViewReducer.Action>)
    }
    
    private enum CancelID { case search }
    @Dependency(\.apiClient) var apiClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchData:
                return .merge (
                    .run { send in
                        let mediaDetails = try? await apiClient.fetchMediaDetails(Routes.getURLPath(forSection: .trending))
                        await send(.dataFetched(.trending, mediaDetails))
                    },
                    .run { send in
                        let mediaDetails = try? await apiClient.fetchMediaDetails(Routes.getURLPath(forSection: .popular))
                        await send(.dataFetched(.popular, mediaDetails))
                    },
                    .run { send in
                        let mediaDetails = try? await apiClient.fetchMediaDetails(Routes.getURLPath(forSection: .tvShows))
                        await send(.dataFetched(.tvShows, mediaDetails))
                    }
                )
                
            case let .dataFetched(section, mediaDetails):
                state.sections[section.rawValue].data = mediaDetails
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
                    await send(.searchResultFetched(Result { try await apiClient.searchMovies(query) }))
                }
                .cancellable(id: CancelID.search)
                
            case let .searchResultFetched(.success(movies)):
                state.searchedResults = movies
                return .none
                
            case .searchResultFetched(.failure):
                state.searchQuery = ""
                state.searchedResults = []
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
