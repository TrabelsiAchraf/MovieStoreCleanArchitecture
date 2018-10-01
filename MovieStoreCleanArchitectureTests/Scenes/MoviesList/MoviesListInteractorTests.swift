//
//  MoviesListInteractorTests.swift
//  MovieStoreCleanArchitectureTests
//
//  Created by Achraf Trabelsi on 9/27/18.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//

import XCTest
@testable import MovieStoreCleanArchitecture

class MoviesListInteractorTests: XCTestCase {

    // MARK: - Subject under test
    
    var sut: MoviesListInteractor!
    
    // MARK: - Test lifeCycle
    
    override func setUp() {
        super.setUp()
        setupListMoviesInteractor()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupListMoviesInteractor() {
        sut = MoviesListInteractor()
    }
    
    // MARK: - Test doubles
    
    class ListMoviesPresentationLogicSpy: MoviesListPresentationLogic {
        // MARK: - Method call expectations
        
        var presentFetchedMoviesCalled = false
        
        // MARK: - Spied methods
        
        func presentFatechedMovies(response: MoviesList.Fetch.Response) {
            presentFetchedMoviesCalled = true
        }
    }
    
    class MoviesWorkerSpy: MoviesWorker {
        // MARK: - Method call expectations
        
        var fetchMoviesCalled = false
        
        // MARK: - Spied methods
        
        override func fetchMovies(completionHandler: @escaping ([Movie]) -> Void) {
            fetchMoviesCalled = true
            completionHandler([Cinema.Movies.harryPotter, Cinema.Movies.spiderman])
        }
    }
    
    // MARK: - Tests
    
    func test_fetchMovies_shouldAsk_moviesWorkerToFetch_And_PresenterToFormatResult() {
        // Given
        let listMoviesPresentationLogicSpy = ListMoviesPresentationLogicSpy()
        sut.presenter = listMoviesPresentationLogicSpy
        let moviesWorkerSpy = MoviesWorkerSpy(moviesStore: MovieMemoryStore())
        sut.moviesWorker = moviesWorkerSpy
        
        // When
        let request = MoviesList.Fetch.Request()
        sut.fetchMovies(request: request)
        
        // Then
        XCTAssert(moviesWorkerSpy.fetchMoviesCalled, "FetchMovies() should ask MoviesWorker to fetch movies")
        XCTAssert(listMoviesPresentationLogicSpy.presentFetchedMoviesCalled, "FetchMovies() should ask presenter to format movies result")
    }
}
