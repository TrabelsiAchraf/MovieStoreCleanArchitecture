//
//  MovieMemoryStore.swift
//  MovieStoreCleanArchitecture
//
//  Created by Achraf TRABELSI on 17/09/2018.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//

import Foundation

class MovieMemoryStore: MoviesStoreProtocol, MoviesStoreUtilityProtocol {
    
    static var movies : [Movie] = []
    
    // MARK: - CRUD operations - Inner closure
    
    func addMovie(movieToAdd: Movie, completionHandler: @escaping (() throws -> Movie?) -> Void) {
        var movie = movieToAdd
        generateMovieID(movie: &movie)
        type(of: self).movies.append(movie)
        completionHandler { return movie }
    }
    
    func fetchMovies(completionHandler: @escaping (() throws -> [Movie]) -> Void) {
        completionHandler { return type(of: self).movies }
    }
}

