//
//  MediaViewTests.swift
//  TheMovieDatabase_TCATests
//
//  Created by Koushik Dutta on 04/06/24.
//

import XCTest
import ComposableArchitecture
@testable import TheMovieDatabase_TCA

final class MediaViewTests: XCTestCase {

    @MainActor
    func testFetchData() async  {
        let store = TestStore(initialState: MediaViewReducer.State(mediaType: .movie)) {
            MediaViewReducer()
        } withDependencies: {
            $0.apiClient.fetchMediaDetails = { _ in [.mock] }
        }
        
        await store.send(.fetchData)
        await store.receive(\.dataFetched){
            $0.mediaArray = [.mock]
        }
    }
    
    
    @MainActor
    func testSortOrderChanged() async {
        let store = TestStore(initialState: MediaViewReducer.State(mediaType: .movie)) {
            MediaViewReducer()
        }
        
        await store.send(.sortOrderChanged(.topRated)){
            $0.currentSortOrder = .topRated
        }
    }
}
