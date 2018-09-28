//
//  Movies.swift
//  MovieStoreCleanArchitectureTests
//
//  Created by Achraf TRABELSI on 17/09/2018.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//

@testable import MovieStoreCleanArchitecture
import XCTest

struct Cinema {
    struct Movies {
        static let harryPotter = Movie(id: "12345", title: "Harry Potter", overview: "A movie about wizard...", releaseDate: 1538132604, rating: 4.5, producer: "Lacha")
        
        static let spiderman = Movie(id: "09876", title: "Spiderman", overview: "A movie about young man...", releaseDate: 1538132604, rating: 3.5, producer: "Kiko")
        
        static let missionImpossible = Movie(id: "515515", title: "Mission Impossible", overview: "A movie about agent...", releaseDate: 1538132604, rating: 4, producer: "Christophe Lacha")
        
        static let lordOfTheRing = Movie(id: "76579", title: "The Lord Of The Ring", overview: "A movie about ...", releaseDate: 1538132604, rating: 4.75, producer: "Adolfe")
    }
}
