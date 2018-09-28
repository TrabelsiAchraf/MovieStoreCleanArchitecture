//
//  MovieMemoryStoreTests.swift
//  MovieStoreCleanArchitectureTests
//
//  Created by Achraf TRABELSI on 17/09/2018.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//
@testable import MovieStoreCleanArchitecture
import XCTest
import Hippolyte

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
        Hippolyte.shared.stop()
    }
    
    // MARK: - Test CRUD operations - Inner closure
    
    func test_CreateMovie_ShouldAdd_NewMovie() {
        // Given
        let movieToAdd = Cinema.Movies.missionImpossible
        
        // When
        var createdMovie: Movie?
        var addMovieError: MoviesStoreError?
        // Create an expectation for a background download task.
        let addMovieExpectation = expectation(description: "Wait for addMovie() to return")
        sut.addMovie(movieToAdd: movieToAdd) { (movie: () throws -> Movie?) in
            _ = try! movie()
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
    
    func test_FetchMovies_ShouldReturn_ListMovies() {
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
    
    
    
    // ***********
    //
//    func test_GetMoviesList_using_XCTestAPI() {
//        guard let url = URL(string: "https://api.github.com/users/shashikant86") else { return }
//        let getMobiesListExpectation = expectation(description: "Get movies list")
//        URLSession.shared.dataTask(with: url) { (data, response
//            , error) in
//            guard let data = data else { return }
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
//                if let result = json as? NSDictionary {
//                    XCTAssertTrue(result["name"] as! String == "Shashikant")
//                    XCTAssertTrue(result["location"] as! String == "London")
//                    getMobiesListExpectation.fulfill()
//                }
//            } catch let err {
//                print("Err", err)
//            }
//            }.resume()
//        waitForExpectations(timeout: 5, handler: nil)
//    }
    
    func test_GetMoviesList_using_HippolyteLib() {
        guard let url = URL(string: "https://api.cinema.com/movies") else { return }
        var stub = StubRequest(method: .GET, url: url)
        var response = StubResponse()
        
        if let path = Bundle(for: type(of: self)).path(forResource: "Movies", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let body = data
                response.body = body as Data?
                stub.response = response
                Hippolyte.shared.add(stubbedRequest: stub)
                Hippolyte.shared.start()
                
                let getMobiesListExpectation = expectation(description: "Get movies list")
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data else { return }
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        if let result = json as? NSDictionary {
                            if let movies = result["Movies"] as? [NSDictionary] {
                                XCTAssertTrue(movies.first!["title"] as! String == "Harry Potter")
                                XCTAssertTrue(movies.first!["producer"] as! String == "TRABELSI Achraf")
                                XCTAssertTrue(movies.first!["rating"] as! Double ==  4.5)
                                getMobiesListExpectation.fulfill()
                            }
                        }
                    } catch let err {
                        print("Err", err)
                    }
                    }.resume()
                waitForExpectations(timeout: 5, handler: nil)
            } catch {}
        }
    }
}
