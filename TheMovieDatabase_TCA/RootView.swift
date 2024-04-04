//
//  RootView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    static let homeStore = Store(initialState: HomeViewReducer.State()) {
        HomeViewReducer()
    }
    
    var body: some View {
        TabView{
            HomeView(viewStore: RootView.homeStore)
                .tabItem {
                    Label("Home", systemImage: "house")
            }
        }
    }
}

#Preview {
    RootView()
}
