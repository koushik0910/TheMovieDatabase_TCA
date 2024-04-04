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
                if viewStore.searchQuery.isEmpty {
                    VStack(spacing: 20){
                        ForEach(viewStore.sections){section in
                            HorizontalMovieView(headerTitle: section.title, movies: section.data)
                        }
                    }
                }else{
                    VerticalSearchView(movies: viewStore.searchedResults)
                }
            }
            .searchable(text: $viewStore.searchQuery.sending(\.searchQueryChanged))
            .task{
                viewStore.send(.fetchData)
            }
            .task(id: viewStore.searchQuery) {
                do{
                    try await Task.sleep(for: .milliseconds(300))
                    await viewStore.send(.searchQueryChangeDebounced).finish()
                }catch { }
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


struct VerticalSearchView: View {
    let movies: [Movie]
    var body: some View {
        ScrollView{
            LazyVStack{
                ForEach(movies, id: \.id) { movie in
                    SearchResultCell(title: movie.titleText, imageURLString: movie.posterFullPath, overview: movie.overview)
                }
            }
        }
    }
}
