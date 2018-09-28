//
//  MoviesListPresenterTests.swift
//  MovieStoreCleanArchitectureTests
//
//  Created by Achraf Trabelsi on 9/27/18.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//

import XCTest
@testable import MovieStoreCleanArchitecture

class MoviesListPresenterTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: MoviesListPresenter!
    
    // MARK: - Test lifeCycle
    
    override func setUp() {
        super.setUp()
        setupMoviesListPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupMoviesListPresenter() {
        sut = MoviesListPresenter()
    }
    
    // MARK: - Test doubles
    
    class MoviesListDisplayLogicSpy: MoviesListDisplayLogic {
        
        // MARK: Method call expectations
        
        var displayFetchedMoviesCalled = false
        
        // AMRK: - Argument expectations
        
        var viewModel: MoviesList.Fetch.ViewModel!
        
        // MARK: Spied methods
        
        func displayFetchedMovies(viewModel: MoviesList.Fetch.ViewModel) {
            displayFetchedMoviesCalled = true
            self.viewModel = viewModel
        }
    }
    
    // MARK: - Tests
    
    func test_PresentFetchMovies_ShouldFormat_MoviesForDisplay() {
        // Given
        let moviesListDisplayLogicSpy = MoviesListDisplayLogicSpy()
        sut.viewController = moviesListDisplayLogicSpy
        
        // When
        let movies = [Cinema.Movies.harryPotter]
        
        let response = MoviesList.Fetch.Response(movies: movies)
        sut.presentFatechedMovies(response: response)
        
        // Then
        let displayedMovies = moviesListDisplayLogicSpy.viewModel.displayedMovies
        for displayedMovie in displayedMovies {
            XCTAssertEqual(displayedMovie.title, "Harry Potter", "Presenting fetched movies should properly format title")
            XCTAssertEqual(displayedMovie.details, "* Date : 9/28/18 - Rating : 4.50", "Presenting fetched movies should properly format details")
        }
    }
    
    func test_PresentFetchedMovies_ShouldAsk_ViewController_ToDisplay_FetchedMovies() {
        // Given
        let moviesListDisplayLogicSpy = MoviesListDisplayLogicSpy()
        sut.viewController = moviesListDisplayLogicSpy
        
        // When
        let movies = [Cinema.Movies.harryPotter]
        let response = MoviesList.Fetch.Response(movies: movies)
        sut.presentFatechedMovies(response: response)
        
        // Then
        XCTAssert(moviesListDisplayLogicSpy.displayFetchedMoviesCalled, "Presenting fetched movies should ask ViewController to display them")
    }
}
