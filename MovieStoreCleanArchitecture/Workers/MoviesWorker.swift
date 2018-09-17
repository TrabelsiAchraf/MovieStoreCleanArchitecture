//
//  MoviesWorker.swift
//  MovieStoreCleanArchitecture
//
//  Created by Achraf TRABELSI on 17/09/2018.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//

import Foundation

class MoviesWorker {
    
    var moviesStore: MoviesStoreProtocol
    
    init(moviesStore: MoviesStoreProtocol) {
        self.moviesStore = moviesStore
    }
    
    func addMovie(movieToAdd: Movie, completionHandler: @escaping (Movie?) -> Void) {
        moviesStore.addMovie(movieToAdd: movieToAdd) { (movie: () throws -> Movie?) in
            do {
                let movie = try movie()
                DispatchQueue.main.async {
                    completionHandler(movie)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
    
}

protocol MoviesStoreProtocol {
    // MARK: CRUD operations - Inner closure
    func addMovie(movieToAdd: Movie, completionHandler: @escaping (() throws -> Movie?) -> Void)
}

protocol MoviesStoreUtilityProtocol {}

extension MoviesStoreUtilityProtocol {
    func generateMovieID(movie: inout Movie) {
        guard movie.id == nil else { return }
        movie.id = "\(arc4random())"
    }
}

enum MoviesStoreError: Equatable, Error {
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotDelete(String)
}
