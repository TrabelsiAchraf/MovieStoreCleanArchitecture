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
    var title: String?
    var overview: String?
    var releaseDate: UInt64?
    var rating: Double?
    var producer: String?
    
    init(id: String?, title: String?, overview: String?, releaseDate: UInt64?, rating: Double?, producer: String?) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.rating = rating
        self.producer = producer
    }
    
    init(dic: NSDictionary) {
        if let id = dic["id"] as? String {
            self.id = id
        }
        
        if let title = dic["title"] as? String {
            self.title = title
        }
        
        if let overview = dic["overview"] as? String {
            self.overview = overview
        }
        
        if let releaseDate = dic["releaseDate"] as? UInt64 {
            self.releaseDate = releaseDate
        }
        
        if let rating = dic["rating"] as? Double {
            self.rating = rating
        }
        
        if let producer = dic["producer"] as? String {
            self.producer = producer
        }
    }
}

struct Movies: Decodable {
    var movies: [Movie]?
}
