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
        var currentTab: Tab
        var home: HomeViewReducer.State
        var movies: MoviesAndTVShowsViewReducer.State
        var tvShows: MoviesAndTVShowsViewReducer.State
        var favourites: FavouritesViewReducer.State
        @Shared var userFavourites: Favourites
        
        init(currentTab: Tab = Tab.home, userFavourites: Shared<Favourites> = Shared(Favourites())) {
            self.currentTab = currentTab
            self.home = HomeViewReducer.State(userFavourites: userFavourites)
            self.movies = MoviesAndTVShowsViewReducer.State(movieType: .movie, userFavourites: userFavourites)
            self.tvShows = MoviesAndTVShowsViewReducer.State(movieType: .tvShow, userFavourites: userFavourites)
            self.favourites = FavouritesViewReducer.State(userFavourites: userFavourites)
            self._userFavourites = userFavourites
        }
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
        
        Scope(state: \.movies, action: \.movies) {
            MoviesAndTVShowsViewReducer()
        }
        
        Scope(state: \.tvShows, action: \.tvShows) {
            MoviesAndTVShowsViewReducer()
        }
        
        Scope(state: \.favourites, action: \.favourites) {
            FavouritesViewReducer()
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
