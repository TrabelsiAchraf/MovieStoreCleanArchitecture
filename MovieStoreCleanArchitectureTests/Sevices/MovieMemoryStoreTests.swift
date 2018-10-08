//
//  MovieMemoryStoreTests.swift
//  MovieStoreCleanArchitectureTests
//
//  Created by Achraf TRABELSI on 17/09/2018.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//
@testable import MovieStoreCleanArchitecture
import XCTest
//import Hippolyte

class MovieMemoryStoreTests: XCTestCase {
    
    var sut: MovieMemoryStore!
    var testMovies: [Movie]!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupMoviesMemoryStore()
    }
    
    override func tearDown() {
        super.tearDown()
        resetMoviesMemoryStore()
//        Hippolyte.shared.stop()
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
    
    // MARK: - Test CRUD operations
    
    func test_createMovie_shouldAdd_newMovie() {
        // Given
        let movieToAdd = Cinema.Movies.missionImpossible
        
        // When
        var createdMovie: Movie?
        var addMovieError: MoviesStoreError?
        // Create an expectation for a background download task.
        let addMovieExpectation = expectation(description: "Wait for addMovie() to return")
        sut.addMovie(movieToAdd: movieToAdd) { (movie: () throws -> Movie?) in
            //_ = try! movie()
            do {
                createdMovie = try movie()
            } catch let error as MoviesStoreError {
                addMovieError = error
            } catch {}
            // Fulfill the expectation to indicate that the background task has finished successfully.
            addMovieExpectation.fulfill()
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 1 seconds.
        waitForExpectations(timeout: 1.0)
        
        // Then
        XCTAssertEqual(createdMovie, movieToAdd, "addMovie() should create a new movie")
        XCTAssertNil(addMovieError, "addMovie() should not return an error")
    }
    
    func test_fetchMovies_shouldReturn_moviesList() {
        // Given
        
        // When
        var fetechedMovies = [Movie]()
        var fetchedMoviesError: MoviesStoreError?
        let expect = expectation(description: "Wait for fetchedMovies() to return")
        sut.fetchMovies { (movies: () throws -> [Movie]) in
            do {
                fetechedMovies = try movies()
            } catch let error as MoviesStoreError {
                fetchedMoviesError = error
            } catch {}
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        // Then
        XCTAssertEqual(fetechedMovies.count, testMovies.count, "fetchedMovies() should return a list of movies")
        
        for movie in fetechedMovies {
            XCTAssert(testMovies.contains(movie), "Fetched movies should match the movies in the data store")
        }
        XCTAssertNil(fetchedMoviesError, "fetchMovies() should not return an error")
    }
    
    func test_should_fetchMovies_fromAPI() {
        // Given
//        guard let url = URL(string: "https://fakeAPI.cinema.com/movies") else { return }
//        var stub = StubRequest(method: .GET, url: url)
//        var response = StubResponse()
        
        // When
        var fetechedMovies = [Movie]()
        var fetchedMoviesError: MoviesStoreError?
        if let path = Bundle(for: type(of: self)).path(forResource: "Movies", ofType: "json") {
            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                response.body = data as Data?
//                stub.response = response
//                Hippolyte.shared.add(stubbedRequest: stub)
//                Hippolyte.shared.start()
                
                let expect = expectation(description: "Fetch movies list")
                
                sut.fetchMoviesAPI { (movies: () throws -> [Movie]) in
                    do {
                        fetechedMovies = try movies()
                    } catch let error as MoviesStoreError {
                        fetchedMoviesError = error
                    } catch {}
                    expect.fulfill()
                }
                
                wait(for: [expect], timeout: 2)
                
            } catch {}
        }
        
        // Then
        XCTAssertEqual(fetechedMovies.first?.title, "Harry Potter")
        XCTAssertEqual(fetechedMovies.count, testMovies.count, "fetchedMovies() should return a list of movies")
        
        for movie in fetechedMovies {
            XCTAssert(testMovies.contains(movie), "Fetched movies should match the movies in the data store")
        }
        XCTAssertNil(fetchedMoviesError, "fetchMovies() should not return an error")
    }
}
