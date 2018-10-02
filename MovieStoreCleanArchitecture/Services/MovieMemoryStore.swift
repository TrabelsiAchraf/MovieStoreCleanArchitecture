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
    
    // MARK: - CRUD operations
    
    func addMovie(movieToAdd: Movie, completionHandler: @escaping (() throws -> Movie?) -> Void) {
        var movie = movieToAdd
        generateMovieID(movie: &movie)
        type(of: self).movies.append(movie)
        completionHandler { return movie }
    }
    
    func fetchMovies(completionHandler: @escaping (() throws -> [Movie]) -> Void) {
        completionHandler { return type(of: self).movies }
    }
    
    func fetchMoviesAPI(completionHandler: @escaping (() throws -> [Movie]) -> Void) {
        guard let url = URL(string: "https://fakeAPI.cinema.com/movies") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                
                let decoder = JSONDecoder()
                let movieData = try decoder.decode(Movies.self, from: data)
                
                if let movies = movieData.movies {
                    type(of: self).movies = movies
                }
                
                completionHandler { return type(of: self).movies }
                
            } catch {
                completionHandler { throw MoviesStoreError.CannotFetch("Cannot fetch movies!")}
            }
            }.resume()
    }
}

