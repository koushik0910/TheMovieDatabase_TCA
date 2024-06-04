//
//  DetailsViewTests.swift
//  TheMovieDatabase_TCATests
//
//  Created by Koushik Dutta on 04/06/24.
//

import XCTest
import ComposableArchitecture
@testable import TheMovieDatabase_TCA

final class DetailsViewTests: XCTestCase {

    @MainActor
    func testFetchCastAndReviews() async  {
        let store = TestStore(initialState: DetailsViewReducer.State(media: .mock)) {
            DetailsViewReducer()
        } withDependencies: {
            $0.apiClient.fetchCastDetails = { _ in [.mock]}
            $0.apiClient.fetchReviews = { _ in [.mock]}
        }
        
        await store.send(.fetchCastAndReviewDetails)
        await store.receive(\.castDetailsFetched) {
            $0.cast = [.mock]
        }
        await store.receive(\.reviewsFetched) {
            $0.reviews = [.mock]
        }
    }
    
    @MainActor
    func testAddToFavourites() async {
        @Shared(.userFavourites) var userFavourites: IdentifiedArrayOf<Media> = []
        let store = TestStore(initialState: DetailsViewReducer.State(media: .mock)) {
            DetailsViewReducer()
        }
        
        await store.send(.favouriteButtonTapped) {
            $0.userFavourites = [.mock]
        }
    }
    
    @MainActor
    func testRemoveFromFavourites() async {
        @Shared(.userFavourites) var userFavourites: IdentifiedArrayOf<Media> = [.mock]
        let store = TestStore(initialState: DetailsViewReducer.State(media: .mock)) {
            DetailsViewReducer()
        }
        
        await store.send(.favouriteButtonTapped) {
            $0.userFavourites = []
        }
    }
}
