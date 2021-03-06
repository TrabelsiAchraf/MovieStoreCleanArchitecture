//
//  AddMovieModels.swift
//  MovieStoreCleanArchitecture
//
//  Created by Achraf TRABELSI on 17/09/2018.
//  Copyright (c) 2018 Achraf TRABELSI. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum AddMovie {
    enum Add {
        struct Request {
            var movieFromFields: Movie
        }
        struct Response {
            var movie: Movie?
        }
        struct ViewModel {
            var movie: Movie?
        }
    }
}
