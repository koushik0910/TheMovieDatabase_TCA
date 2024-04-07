//
//  MovieCollectionView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import SwiftUI

struct MovieCollectionView: View {
    let movies: [Movie]
    let favourites: Favourites
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(movies, id: \.id) { movie in
                    NavigationLink(state: DetailsViewReducer.State(movie: movie, favourites: favourites)) {
                        MovieCell(title: movie.titleText, imageURLString: movie.posterFullPath, releaseDate: movie.dateText)
                    }
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    MovieCollectionView(movies: [Movie.mockData()], favourites: Favourites())
}
