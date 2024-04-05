//
//  MovieCollectionView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import SwiftUI

struct MovieCollectionView: View {
    let movies: [Movie]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(movies, id: \.id) { movie in
                    MovieCell(title: movie.titleText, imageURLString: movie.posterFullPath, releaseDate: movie.dateText)
                    
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    MovieCollectionView(movies: [Movie.mockData()])
}
