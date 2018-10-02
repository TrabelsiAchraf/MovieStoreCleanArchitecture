//
//  Movie.swift
//  MovieStoreCleanArchitecture
//
//  Created by Achraf TRABELSI on 17/09/2018.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//

import Foundation

struct Movie: Decodable, Equatable {
    var id: String?
    var title: String
    var overview: String
    var releaseDate: UInt64
    var rating: Double
    var producer: String
}

struct Movies: Decodable {
    var movies: [Movie]?
}
