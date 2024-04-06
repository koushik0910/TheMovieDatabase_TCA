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
        var currentTab = Tab.home
        var home = HomeViewReducer.State()
        var movies = MoviesAndTVShowsViewReducer.State(isMovie: true)
        var tvShows = MoviesAndTVShowsViewReducer.State(isMovie: false)
        var favourites = FavouritesViewReducer.State()
    }
    
    enum Action {
        case home(HomeViewReducer.Action)
        case movies(MoviesAndTVShowsViewReducer.Action)
        case tvShows(MoviesAndTVShowsViewReducer.Action)
        case favourites(FavouritesViewReducer.Action)
        case selectTab(Tab)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.home, action: \.home) {
            HomeViewReducer()
        }
        .onChange(of: \.home.favourites) { _, favourites in
            Reduce { state, _ in
                state.favourites.favourites = favourites
                state.movies.favourites = favourites
                state.tvShows.favourites = favourites
                return .none
            }
        }
        
        Scope(state: \.movies, action: \.movies) {
            MoviesAndTVShowsViewReducer()
        }
        .onChange(of: \.movies.favourites) { _, favourites in
            Reduce { state, _ in
                state.favourites.favourites = favourites
                state.home.favourites = favourites
                state.tvShows.favourites = favourites
                return .none
            }
        }
        
        Scope(state: \.tvShows, action: \.tvShows) {
            MoviesAndTVShowsViewReducer()
        }
        .onChange(of: \.tvShows.favourites) { _, favourites in
            Reduce { state, _ in
                state.favourites.favourites = favourites
                state.movies.favourites = favourites
                state.home.favourites = favourites
                return .none
            }
        }
        
        Scope(state: \.favourites, action: \.favourites) {
            FavouritesViewReducer()
        }
        .onChange(of: \.favourites.favourites) { _, favourites in
            Reduce { state, _ in
                state.home.favourites = favourites
                state.movies.favourites = favourites
                state.tvShows.favourites = favourites
                return .none
            }
        }
        
        Reduce { state, action in
            switch action {
            case .home, .movies, .tvShows, .favourites:
                return .none
            case let .selectTab(tab):
                state.currentTab = tab
                return .none
            }
        }
    }
}
