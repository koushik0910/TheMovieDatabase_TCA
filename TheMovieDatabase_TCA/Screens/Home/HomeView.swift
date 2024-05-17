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
        NavigationStack(path: $viewStore.scope(state: \.path, action: \.path)){
            ScrollView{
                if viewStore.searchQuery.isEmpty {
                    ForEach(viewStore.sections){ section in
                        HorizontalMovieView(headerTitle: section.title, movies: section.data, favourites: viewStore.$userFavourites)
                    }
                }else{
                    VerticalSearchView(movies: viewStore.searchedResults, favourites: viewStore.$userFavourites)
                }
            }
            .navigationTitle("TMDB")
            .searchable(text: $viewStore.searchQuery.sending(\.searchQueryChanged))
            .task {
                viewStore.send(.fetchData)
            }
            .task(id: viewStore.searchQuery) {
                do{
                    try await Task.sleep(for: .milliseconds(300))
                    await viewStore.send(.searchQueryChangeDebounced).finish()
                }catch { }
            }
        }destination: { store in
            DetailsView(viewStore: store)
        }
    }
}

#Preview {
    HomeView(viewStore: Store(initialState: HomeViewReducer.State(userFavourites: Shared(Favourites())), reducer: { HomeViewReducer() }))
}

struct HorizontalMovieView: View {
    let headerTitle: String
    let movies: [Movie]
    let favourites: Shared<Favourites>
    
    var body: some View {
        VStack(alignment:.leading){
            Text(headerTitle)
                .bold()
                .font(.title2)
                .padding()
            ScrollView(.horizontal) {
                LazyHStack(spacing: 15) {
                    ForEach(movies) { movie in
                        NavigationLink(state: DetailsViewReducer.State(movie: movie, userFavourites: favourites)) {
                            MovieCell(title: movie.titleText, imageURLString: movie.posterFullPath, releaseDate: movie.dateText)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct VerticalSearchView: View {
    let movies: [Movie]
    let favourites: Shared<Favourites>
    var body: some View {
        ScrollView{
            LazyVStack{
                ForEach(movies) { movie in
                    NavigationLink(state: DetailsViewReducer.State(movie: movie, userFavourites: favourites)) {
                        SearchResultCell(title: movie.titleText, imageURLString: movie.posterFullPath, overview: movie.overview)
                    }
                }
            }
        }
    }
}
