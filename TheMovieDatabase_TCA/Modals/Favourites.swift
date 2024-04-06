//
//  Favourites.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 05/04/24.
//

import Foundation

struct Favourites: Equatable {
    private(set) var movies = Set<Movie>()
    
    mutating func addMovies(_ movie: Movie) {
        movies.insert(movie)
    }
    
    mutating func removeMovies(_ movie: Movie) {
        movies.remove(movie)
    }
    
    func isFavourite(_ movie: Movie) -> Bool {
        return movies.contains(movie)
    }
}
