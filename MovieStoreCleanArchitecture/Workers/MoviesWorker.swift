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
    
    func fetchMovies(completionHandler: @escaping ([Movie]) -> Void) {
        moviesStore.fetchMovies { (movies: () throws -> [Movie]) in
            do {
                let movies = try movies()
                DispatchQueue.main.async {
                    completionHandler(movies)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler([])
                }
            }
        }
    }
}

protocol MoviesStoreProtocol {
    // MARK: CRUD operations
    func addMovie(movieToAdd: Movie, completionHandler: @escaping (() throws -> Movie?) -> Void)
    func fetchMovies(completionHandler: @escaping (() throws -> [Movie]) -> Void)
}

protocol MoviesStoreUtilityProtocol {}

extension MoviesStoreUtilityProtocol {
    func generateMovieID(movie: inout Movie) {
        guard movie.id == nil else { return }
        movie.id = "\(arc4random())"
    }
}

enum MoviesStoreError: Error {
    case CannotFetch(String)
    case CannotCreate(String)
}
