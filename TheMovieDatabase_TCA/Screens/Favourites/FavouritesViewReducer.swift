//
//  FavouriteReducer.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 05/04/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct FavouritesViewReducer {

    @ObservableState
    struct State: Equatable {
        var path = StackState<DetailsViewReducer.State>()
        @SharedReader(.userFavourites) var userFavourites: IdentifiedArrayOf<Media> = []
    }
    
    enum Action {
        case path(StackAction<DetailsViewReducer.State, DetailsViewReducer.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            DetailsViewReducer()
        }
    }
}

// for type safety
extension PersistenceReaderKey where Self == FileStorageKey<IdentifiedArrayOf<Media>> {
    static var userFavourites : Self {
        fileStorage(.userFavourites)
    }
}
