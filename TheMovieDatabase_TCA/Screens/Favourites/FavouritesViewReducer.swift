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
        var favourites = Favourites()
    }
    
    enum Action {
        case path(StackAction<DetailsViewReducer.State, DetailsViewReducer.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path(.element(id: _, action: .delegate(.addOrRemoveFavourites(let movie)))):
                state.favourites.isFavourite(movie) ? state.favourites.removeMovies(movie) : state.favourites.addMovies(movie)
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
