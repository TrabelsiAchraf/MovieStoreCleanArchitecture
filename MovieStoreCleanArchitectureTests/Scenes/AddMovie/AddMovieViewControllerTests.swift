//
//  AddMovieViewControllerTests.swift
//  MovieStoreCleanArchitectureTests
//
//  Created by Achraf TRABELSI on 18/09/2018.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//

@testable import MovieStoreCleanArchitecture
import UIKit
import XCTest

class AddMovieViewControllerTests: XCTestCase {

    // MARK: - Subject under test
    
    var sut: AddMovieViewController!
    var window: UIWindow!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupAddMovieViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupAddMovieViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "AddMovieViewControllerTests") as? AddMovieViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: - Test doubles
    
    class AddMovieBusinessLogicSpy: AddMovieBusinessLogic {
        
        // MARK: Method call expectations
        
        var addMovieCalled = false
        
        // MARK: Argument expectations
        
        var addMovieRequest: AddMovie.Add.Request!
        
        // MARK: Spied methods
        
        func addMovie(request: AddMovie.Add.Request) {
            addMovieCalled = true
            self.addMovieRequest = request
        }
    }
    
//    class AddMovieRouterSpy: AddMovieRouter {
//
//        // MARK: Method call expectations
    
//    override func routeToListMovies(segue: UIStoryboardSegue?) {
//        routeToListMoviesCalled = true
//    }
//    }
}
