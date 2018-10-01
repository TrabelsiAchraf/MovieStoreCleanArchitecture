//
//  MoviesWorkerTests.swift
//  MovieStoreCleanArchitectureTests
//
//  Created by Achraf Trabelsi on 9/17/18.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//

import XCTest
@testable import MovieStoreCleanArchitecture

class MoviesWorkerTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: MoviesWorker!
    static var testMovies: [Movie]!
    
    // MARK: - Test lifeCycle
    
    override func setUp() {
        super.setUp()
        setupMoviesWorker()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupMoviesWorker() {
        sut = MoviesWorker(moviesStore: MovieMemoryStoreSpy())
        MoviesWorkerTests.testMovies = [Cinema.Movies.harryPotter, Cinema.Movies.lordOfTheRing]
    }
    
    // MARK: - Test doubles
    
    class MovieMemoryStoreSpy: MovieMemoryStore {
        
        // MARK: Method call expectations
        
        var fetchedMoviesCalled = false
        var addMovieCalled = false
        
        // MARK: - Spied methods
        
        override func fetchMovies(completionHandler: @escaping (() throws -> [Movie]) -> Void) {
            fetchedMoviesCalled = true
            completionHandler { () -> [Movie] in
                return MoviesWorkerTests.testMovies
            }
        }
        
        override func addMovie(movieToAdd: Movie, completionHandler: @escaping (() throws -> Movie?) -> Void) {
            addMovieCalled = true
            completionHandler { () -> Movie in
                return MoviesWorkerTests.testMovies.first!
            }
        }
    }
    
    // MARK: - Tests
    
    func test_fetchMovies_should_return_listOfMovies() {
        // Given
        let movieMemoryStoreSpy = sut.moviesStore as! MovieMemoryStoreSpy
        
        // When
        var fetchedMovies = [Movie]()
        let expect = expectation(description: "Wait for fetchMovies() to return")
        sut.fetchMovies { (movies) in
            fetchedMovies = movies
            expect.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        // Then
        XCTAssert(movieMemoryStoreSpy.fetchedMoviesCalled, "Calling fetchMovies() should ask the data store for a list of movies")
        XCTAssertEqual(fetchedMovies.count, MoviesWorkerTests.testMovies.count, "fetchMovies() should return a list of movies")
        for movie in fetchedMovies {
            XCTAssert(MoviesWorkerTests.testMovies.contains(movie), "Fetched movies should match the movies in the data store")
        }
    }
    
    func test_createMovie_should_returnTheCreatedMovie() {
        // Given
        let movieMemoryStoreSpy = sut.moviesStore as! MovieMemoryStoreSpy
        let movieToCreate = MoviesWorkerTests.testMovies.first!
        
        // When
        var createdMovie: Movie?
        let expect = expectation(description: "Wait for addMovie() to return")
        sut.addMovie(movieToAdd: movieToCreate) { (movie) in
            createdMovie = movie
            expect.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        // Then
        XCTAssert(movieMemoryStoreSpy.addMovieCalled, "Calling createOrder() should ask the data store to create the new movie")
        XCTAssertEqual(createdMovie, movieToCreate, "addMovie() should create the new movie")
    }
}
