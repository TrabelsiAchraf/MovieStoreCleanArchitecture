//
//  MovieMemoryStoreTests.swift
//  MovieStoreCleanArchitectureTests
//
//  Created by Achraf TRABELSI on 17/09/2018.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//
@testable import MovieStoreCleanArchitecture
import XCTest

class MovieMemoryStoreTests: XCTestCase {

    var sut: MovieMemoryStore!
    var testMovies: [Movie]!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        setupMoviesMemoryStore()
    }

    override func tearDown() {
        resetMoviesMemoryStore()
    }
    
    // MARK: - Test setup
    
    func setupMoviesMemoryStore() {
        sut = MovieMemoryStore()
        testMovies = [Cinema.Movies.harryPotter, Cinema.Movies.spiderman]
        MovieMemoryStore.movies = testMovies
    }
    
    func resetMoviesMemoryStore() {
        MovieMemoryStore.movies = []
        sut = nil
    }
    
    // MARK: - Test CRUD operations - Inner closure
    
    
    func test_CreateMovie_ShouldAdd_NewMovie_InnerClosure() {
        // Given
        let movieToAdd = Cinema.Movies.missionImpossible
        
        // When
        var createdMovie: Movie?
        var addMovieError: MoviesStoreError?
        let addMovieExpectation = expectation(description: "Wait for addMovie() to return")
        sut.addMovie(movieToAdd: movieToAdd) { (movie: () throws -> Movie?) in
            _ = try! movie()
            do {
                createdMovie = try movie()
            } catch let error as MoviesStoreError {
                addMovieError = error
            } catch {}
            addMovieExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        
        // Then
        XCTAssertEqual(createdMovie, movieToAdd, "addMovie() should create a new movie")
        XCTAssertNil(addMovieError, "addMovie() should not return an error")
    }
}
