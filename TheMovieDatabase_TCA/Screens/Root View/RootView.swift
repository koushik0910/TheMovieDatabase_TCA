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
        TabView {
            HomeView(viewStore: self.viewStore.scope(state: \.home, action: \.home))
                .tabItem {
                    Label("Home", systemImage: "house")
            }
            
            MediaView(viewStore: self.viewStore.scope(state: \.movies, action: \.movies))
                .tabItem {
                    Label("Movies", systemImage: "movieclapper")
            }
            
            MediaView(viewStore: self.viewStore.scope(state: \.tvShows, action: \.tvShows))
                .tabItem {
                    Label("TV Shows", systemImage: "play.tv")
            }
            
            FavouritesView(viewStore: self.viewStore.scope(state: \.favourites, action: \.favourites))
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
