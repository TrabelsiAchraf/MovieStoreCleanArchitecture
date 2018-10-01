//
//  AddMovieInteractorTests.swift
//  MovieStoreCleanArchitectureTests
//
//  Created by Achraf TRABELSI on 18/09/2018.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//

@testable import MovieStoreCleanArchitecture
import XCTest

class AddMovieInteractorTests: XCTestCase {

    // MARK: - Subject under test
    
    var sut: AddMovieInteractor!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupAddMovieInteractor()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupAddMovieInteractor() {
        sut = AddMovieInteractor()
    }
    
    class AddMoviePresentationLogicSpy: AddMoviePresentationLogic {
        
        // MARK: Method call expectations
        
        var presentAddMovieCalled = false
        
        // MARK: Spied methods
        
        func presentAddMovie(response: AddMovie.Add.Response) {
            presentAddMovieCalled = true
        }
    }
    
    class MoviesWorkerSpy: MoviesWorker {
        
        // MARK: Method call expectations
        
        var addMovieCalled = false
        
        // MARK: Spied methods
        
        override func addMovie(movieToAdd: Movie, completionHandler: @escaping (Movie?) -> Void) {
            addMovieCalled = true
            completionHandler(Cinema.Movies.lordOfTheRing)
        }
    }
    
    // MARK: - Test add a new movie
    
    func test_createMovie_should_ask_MoviesWorker_toCreate_theNewMovie_and_presenter_toFormatIt() {
        // Given
        let addMoviePresentationLogicSpy = AddMoviePresentationLogicSpy()
        sut.presenter = addMoviePresentationLogicSpy
        let moviesWorkerSpy = MoviesWorkerSpy(moviesStore: MovieMemoryStore())
        sut.moviesWorker = moviesWorkerSpy
        
        // When
        let request = AddMovie.Add.Request(movieFromFields: Movie(id: "00", title: "", overview: "", releaseDate: 1538132604, rating: 0, producer: ""))
        sut.addMovie(request: request)
        
        // Then
        XCTAssert(moviesWorkerSpy.addMovieCalled, "AddMovie() should ask MoviesWorker to add the new movie")
        XCTAssert(addMoviePresentationLogicSpy.presentAddMovieCalled, "AddMovie() should ask presenter to format the newly created movie")
    }    
}
