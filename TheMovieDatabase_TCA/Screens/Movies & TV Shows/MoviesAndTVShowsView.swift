//
//  MoviesView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import SwiftUI
import ComposableArchitecture

struct MoviesAndTVShowsView: View {
    @Bindable var viewStore: StoreOf<MoviesAndTVShowsViewReducer>
    var body: some View {
        NavigationStack(path: $viewStore.scope(state: \.path, action: \.path)){
            MovieCollectionView(movies: viewStore.movies)
                .task(id: viewStore.currentSortOrder){
                    viewStore.send(.fetchData)
                }
                .toolbar {
                    SortToolBarContent { order in
                        viewStore.send(.sortOrderChanged(order))
                    }
                }
                .navigationTitle(viewStore.currentSortOrder.rawValue)
        }destination: { store in
            DetailsView(viewStore: store)
        }
    }
}

#Preview {
    MoviesAndTVShowsView(viewStore: Store(initialState: MoviesAndTVShowsViewReducer.State(isMovie: true), reducer: {
        MoviesAndTVShowsViewReducer()
    }))
}


struct SortToolBarContent: ToolbarContent {
    var action: (SortOrder) -> ()
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu(content: {
                ForEach(SortOrder.allCases, id: \.hashValue){ order in
                    Button(order.rawValue){
                        action(order)
                    }
                }
            }, label: {Text("Sort")})
        }
    }
}
