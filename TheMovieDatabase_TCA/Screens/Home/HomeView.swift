//
//  HomeView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    @Bindable var viewStore: StoreOf<HomeViewReducer>
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(spacing: 20){
                    ForEach(viewStore.sections){section in
                        HorizontalMovieView(headerTitle: section.title, movies: section.data)
                    }
                }
            }
            .task{
                viewStore.send(.fetchData)
            }
        }
    }
}

#Preview {
    HomeView(viewStore: Store(initialState: HomeViewReducer.State(), reducer: { HomeViewReducer() }))
}


struct HorizontalMovieView: View {
    let headerTitle: String
    let movies: [Movie]
    var body: some View {
        VStack(alignment:.leading ,spacing: 20){
            Text(headerTitle)
                .bold()
                .font(.title)
                .padding(.leading, 16)
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 20) {
                    ForEach(movies, id: \.id) { movie in
                        MovieCell(title: movie.titleText, imageURLString: movie.posterFullPath, releaseDate: movie.dateText)
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)
        }
    }
}
