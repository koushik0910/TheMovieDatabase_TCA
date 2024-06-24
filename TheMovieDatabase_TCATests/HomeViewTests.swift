//
//  HomeViewTests.swift
//  TheMovieDatabase_TCATests
//
//  Created by Koushik Dutta on 04/06/24.
//

import XCTest
import ComposableArchitecture
@testable import TheMovieDatabase_TCA

final class HomeViewTests: XCTestCase {
    
    @MainActor
    func testFetchSections() async {
        let store = TestStore(initialState: HomeViewReducer.State()) {
            HomeViewReducer()
        }withDependencies: {
            $0.apiClient.fetchMediaDetails = { _ in IdentifiedArray(arrayLiteral: .mock) }
        }
        
        await store.send(.fetchData)
        await store.receive(\.dataFetched) {
            $0.sections = [HomeSectionData(id: .trending, title: HomeSection.trending.rawValue, data: [.mock]), HomeSectionData(id: .popular, title: HomeSection.popular.rawValue, data: [.mock]), HomeSectionData(id: .tvShows, title: HomeSection.tvShows.rawValue, data: [.mock])]
        }
    }
    
    @MainActor
    func testFetchSectionsFailure() async {
        let store = TestStore(initialState: HomeViewReducer.State()) {
            HomeViewReducer()
        }withDependencies: {
            $0.apiClient.fetchMediaDetails = { _ in throw URLError(.badServerResponse) }
        }
        
        await store.send(.fetchData)
        await store.receive(\.dataFetched) {
            $0.sections = [HomeSectionData(id: .trending, title: HomeSection.trending.rawValue, data: nil), HomeSectionData(id: .popular, title: HomeSection.popular.rawValue, data: nil), HomeSectionData(id: .tvShows, title: HomeSection.tvShows.rawValue, data: nil)]
        }
    }
    
    
    @MainActor
    func testSearchAndClearQuery() async {
        let store = TestStore(initialState: HomeViewReducer.State()) {
            HomeViewReducer()
        }withDependencies: {
            $0.apiClient.searchMovies = { _ in IdentifiedArray(arrayLiteral: .mock) }
        }
        
        await store.send(.searchQueryChanged("T")){
            $0.searchQuery = "T"
        }
        await store.send(.searchQueryChangeDebounced)
        await store.receive(\.searchResultFetched.success){
            $0.searchedResults = [.mock]
        }
        
        await store.send(.searchQueryChanged("")) {
            $0.searchedResults = []
            $0.searchQuery = ""
        }
    }
    
    @MainActor
    func testSerchFailure() async {
        let store = TestStore(initialState: HomeViewReducer.State()) {
            HomeViewReducer()
        }withDependencies: {
            $0.apiClient.searchMovies = { _ in throw URLError(.badServerResponse) }
        }
        
        await store.send(.searchQueryChanged("T")){
            $0.searchQuery = "T"
        }
        await store.send(.searchQueryChangeDebounced)
        await store.receive(\.searchResultFetched.failure){
            $0.searchedResults = []
            $0.searchQuery = ""
        }
    }

}
