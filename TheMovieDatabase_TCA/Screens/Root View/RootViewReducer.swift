//
//  RootViewReducer.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 05/04/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RootViewReducer {
    enum Tab {
        case home, movies, tvShows, favourites
    }
    
    @ObservableState
    struct State: Equatable {
        var home = HomeViewReducer.State()
        var movies = MediaViewReducer.State(mediaType: .movie)
        var tvShows = MediaViewReducer.State(mediaType: .tv)
        var favourites = FavouritesViewReducer.State()
    }
    
    enum Action {
        case home(HomeViewReducer.Action)
        case movies(MediaViewReducer.Action)
        case tvShows(MediaViewReducer.Action)
        case favourites(FavouritesViewReducer.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.home, action: \.home) {
            HomeViewReducer()
        }
        
        Scope(state: \.movies, action: \.movies) {
            MediaViewReducer()
        }
        
        Scope(state: \.tvShows, action: \.tvShows) {
            MediaViewReducer()
        }
        
        Scope(state: \.favourites, action: \.favourites) {
            FavouritesViewReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .home, .movies, .tvShows, .favourites:
                return .none
            }
        }
    }
}
