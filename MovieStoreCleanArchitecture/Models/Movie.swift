//
//  Movie.swift
//  MovieStoreCleanArchitecture
//
//  Created by Achraf TRABELSI on 17/09/2018.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//

import Foundation

struct Movie: Equatable {
    var id: String?
    var title: String
    var overview: String
    var releaseDate: Date
    var rating: Double
    var producer: String
}
