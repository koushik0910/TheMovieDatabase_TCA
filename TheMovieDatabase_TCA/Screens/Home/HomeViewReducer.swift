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
        var sections : [SectionData] = []
        var searchQuery = ""
        var searchedResults: [Movie] = []
        var path = StackState<DetailsViewReducer.State>()
        var favourites = Favourites()
    }
    
    enum Action {
        case fetchData
        case dataFetched([Section:[Movie]])
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchResultFetched([Movie])
        case path(StackAction<DetailsViewReducer.State, DetailsViewReducer.Action>)
    }
    
    private enum CancelID { case search }
    @Dependency(\.apiClient) var apiClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchData:
                return .run { send in
                    let data: [Section : [Movie]] =  try await withThrowingTaskGroup(of: (Section, [Movie]).self) { group in
                        for item in Section.allCases{
                            group.addTask {
                                return try await (item, apiClient.fetchMovies(item.urlString))
                            }
                        }
                        var result = [Section: [Movie]]()
                        for try await item in group{
                            result[item.0] = item.1
                        }
                        return result
                    }
                    await send(.dataFetched(data))
                }
            case let .dataFetched(data):
                var section: [SectionData] = []
                for item in Section.allCases {
                    section.append(SectionData(id: item, title: item.rawValue, data: data[item]!))
                }
                state.sections = section
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
                    let result = try await apiClient.searchMovies(query)
                    await send(.searchResultFetched(result))
                }
                .cancellable(id: CancelID.search)
            case let .searchResultFetched(movies):
                state.searchedResults = movies
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
