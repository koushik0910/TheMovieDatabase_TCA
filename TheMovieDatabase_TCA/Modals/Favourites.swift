//
//  Favourites.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 05/04/24.
//

import Foundation

struct Favourites: Equatable {
    private(set) var movies = Set<Movie>()
    
    mutating func addOrRemoveMovies(_ movie: Movie) {
        if !movies.insert(movie).inserted {
            movies.remove(movie)
        }
    }
    
    func isFavourite(_ movie: Movie) -> Bool{
        return movies.contains(movie)
    }
}
