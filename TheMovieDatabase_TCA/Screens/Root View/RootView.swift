//
//  RootView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    @Bindable var viewStore: StoreOf<RootViewReducer>
    
    var body: some View {
        TabView(selection: $viewStore.currentTab.sending(\.selectTab)){
            
            HomeView(viewStore: self.viewStore.scope(state: \.home, action: \.home))
                .tag(RootViewReducer.Tab.home)
                .tabItem {
                    Label("Home", systemImage: "house")
            }
            
            MoviesAndTVShowsView(viewStore: self.viewStore.scope(state: \.movies, action: \.movies))
                .tag(RootViewReducer.Tab.movies)
                .tabItem {
                    Label("Movies", systemImage: "movieclapper")
            }
            
            MoviesAndTVShowsView(viewStore: self.viewStore.scope(state: \.tvShows, action: \.tvShows))
                .tag(RootViewReducer.Tab.tvShows)
                .tabItem {
                    Label("TV Shows", systemImage: "play.tv")
            }
            
            FavouritesView(viewStore: self.viewStore.scope(state: \.favourites, action: \.favourites))
                .tag(RootViewReducer.Tab.favourites)
                .tabItem {
                    Label("Favourites", systemImage: "heart")
                } 
        }
        .tint(.black)
    }
}

#Preview {
    RootView(
        viewStore: Store(initialState: RootViewReducer.State()) {
          RootViewReducer()
      }
    )
}
