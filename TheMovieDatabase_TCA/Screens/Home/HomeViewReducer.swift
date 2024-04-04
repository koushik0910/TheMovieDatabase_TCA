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
    }
    
    enum Action {
        case fetchData
        case dataFetched([Section:[Movie]])
    }
    
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
                for item in Section.allCases{
                    section.append(SectionData(title: item.title, data: data[item]!))
                }
                state.sections = section
                return .none
            }
        }
    }
}
