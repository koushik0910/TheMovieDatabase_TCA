//
//  RootView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    static let homeStore = Store(initialState: HomeViewReducer.State()) { HomeViewReducer() }
    
    static let moviesStore = Store(initialState: MoviesAndTVShowsViewReducer.State(isMovie: true)) { MoviesAndTVShowsViewReducer() }
    
    static let tvShowStore = Store(initialState: MoviesAndTVShowsViewReducer.State(isMovie: false)) { MoviesAndTVShowsViewReducer() }
    
    
    var body: some View {
        TabView{
            HomeView(viewStore: RootView.homeStore)
                .tabItem {
                    Label("Home", systemImage: "house")
            }
            
            MoviesAndTVShowsView(viewStore: RootView.moviesStore)
                .tabItem {
                    Label("Movies", systemImage: "movieclapper")
            }
            
            MoviesAndTVShowsView(viewStore: RootView.tvShowStore)
                .tabItem {
                    Label("TV Shows", systemImage: "play.tv")
            }
        }
        .tint(.black)
    }
}

#Preview {
    RootView()
}
