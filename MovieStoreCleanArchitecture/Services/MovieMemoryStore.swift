//
//  MovieMemoryStore.swift
//  MovieStoreCleanArchitecture
//
//  Created by Achraf TRABELSI on 17/09/2018.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//

import Foundation
import Alamofire

class MovieMemoryStore: MoviesStoreProtocol, MoviesStoreUtilityProtocol {
    
    static var movies : [Movie] = []
    
    // MARK: - CRUD operations
    
    func addMovie(movieToAdd: Movie, completionHandler: @escaping (() throws -> Movie?) -> Void) {
        var movie = movieToAdd
        generateMovieID(movie: &movie)
        type(of: self).movies.append(movie)
        completionHandler { return movie }
    }
    
    func fetchMoviesAPI(completionHandler: @escaping (() throws -> [Movie]) -> Void) {
        Alamofire.request(URL(string: Constants.Paths.fetchMovies)!, method: .get)
            .responseJSON { (dataResponse) in
                guard let moviesDic = dataResponse.result.value as? NSDictionary else { return }
                if dataResponse.response!.statusCode == 200 {
                    for movieDic in moviesDic.value(forKey: "Movies") as! [NSDictionary] {
                        let movie = Movie(dic: movieDic)
                        type(of: self).movies.append(movie)
                    }
                    completionHandler { return type(of: self).movies }
                }
        }
    }
}
