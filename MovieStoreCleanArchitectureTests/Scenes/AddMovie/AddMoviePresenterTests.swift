//
//  AddMoviePresenterTests.swift
//  MovieStoreCleanArchitectureTests
//
//  Created by Achraf TRABELSI on 18/09/2018.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//

@testable import MovieStoreCleanArchitecture
import XCTest

class AddMoviePresenterTests: XCTestCase {

    // MARK: - Subject under test
    
    var sut: AddMoviePresenter!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        setupAddMoviePresenter()
    }

    override func tearDown() {

    }
    
    // MARK: - Test setup
    
    func setupAddMoviePresenter() {
        sut = AddMoviePresenter()
    }

    // MARK: - Test doubles
    
    class AddMoviePresentationLogicSpy: AddMovieDisplayLogic {
        
        // MARK: Method call expectations
        
        var displayAddMovieCalled = false
    
        // MARK: Argument expectations
        
        var addMovieViewModel: AddMovie.Add.ViewModel!
        
        // MARK: Spied methods
        
        func displayAddMovie(viewModel: AddMovie.Add.ViewModel) {
            displayAddMovieCalled = true
            self.addMovieViewModel = viewModel
        }
    }
    
    // MARK: - Test created movie
    
    func test_PresentAddMovie_should_Ask_ViewController_toDisplay_theNewly_addMovie() {
        // Given
        let addMoviePresentationLogicSpy = AddMoviePresentationLogicSpy()
        sut.viewController = addMoviePresentationLogicSpy
        
        // When
        let movie = Cinema.Movies.lordOfTheRing
        let response = AddMovie.Add.Response(movie: movie)
        sut.presentAddMovie(response: response)
        
        // Then
        XCTAssert(addMoviePresentationLogicSpy.displayAddMovieCalled, "Presenting the newly add movie should ask view controller to display it")
        XCTAssertNotNil(addMoviePresentationLogicSpy.addMovieViewModel.movie, "Presenting the newly add movie should succeed")
    }
}
