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
        case dataFetched([HomeSections: IdentifiedArrayOf<Media>?])
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
                return .run { send in
                    let data: [HomeSections : IdentifiedArrayOf<Media>?] =  await withTaskGroup(of: (HomeSections, IdentifiedArrayOf<Media>?).self) { group in
                        for item in HomeSections.allCases{
                            group.addTask {
                                return (item, try? await apiClient.fetchMediaDetails(item.path))
                            }
                        }
                        var result = [HomeSections: IdentifiedArrayOf<Media>?]()
                        for await item in group {
                            result[item.0] = item.1
                        }
                        return result
                    }
                    await send(.dataFetched(data))
                }
                
            case let .dataFetched(data):
                var section: IdentifiedArrayOf<HomeSectionData> = []
                for item in HomeSections.allCases {
                    section.append(HomeSectionData(id: item, title: item.rawValue, data: data[item] as? IdentifiedArrayOf<Media>))
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
