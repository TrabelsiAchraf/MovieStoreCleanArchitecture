//
//  AddMoviePresenter.swift
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

protocol AddMoviePresentationLogic {
    func presentAddMovie(response: AddMovie.Add.Response)
}

class AddMoviePresenter: AddMoviePresentationLogic {
   
    weak var viewController: AddMovieDisplayLogic?
    
    // MARK: Present add movie
    
    func presentAddMovie(response: AddMovie.Add.Response) {
        let viewModel = AddMovie.Add.ViewModel(movie: response.movie)
        viewController?.displayAddMovie(viewModel: viewModel)
    }
}
