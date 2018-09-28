//
//  MoviesListViewControllerTests.swift
//  MovieStoreCleanArchitectureTests
//
//  Created by Achraf Trabelsi on 9/27/18.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//

import XCTest
@testable import MovieStoreCleanArchitecture

class MoviesListViewControllerTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: MoviesListViewController!
    var window: UIWindow!
    
    // MARK: - Test lifeCycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupMoviesListViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupMoviesListViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        sut = (storyboard.instantiateViewController(withIdentifier: "MoviesListViewController") as! MoviesListViewController)
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: - Test doubles
    
    class MoviesListBusinessLogicSpy: MoviesListBusinessLogic {
        
        var movies: [Movie]?
        
        // MARK: - Method call expectations
        
        var fetchMoviesCalled = false
        
        // MARK: - Spied methods
        
        func fetchMovies(request: MoviesList.Fetch.Request) {
            fetchMoviesCalled = true
        }
    }
    
    class TableViewSpy: UITableView {
        
        // MARK: - Method call expectations
        
        var reloadDataCalled = false
        
        //MARK: - Spied methods
        
        override func reloadData() {
            reloadDataCalled = true
        }
    }
    
    // MARK: - Tests
    
    func test_Should_FetchMovies_When_ViewDidAppear() {
        // Given
        let moviesListBusinessLogicSpy = MoviesListBusinessLogicSpy()
        sut.interactor = moviesListBusinessLogicSpy
        loadView()
        
        // When
        sut.viewDidAppear(true)
        
        // Then
        XCTAssert(moviesListBusinessLogicSpy.fetchMoviesCalled, "Should fetch movies right after the view appears")
    }
    
    func test_Should_Display_FetchedMovies() {
        // Given
        let tableViewSpy = TableViewSpy()
        sut.tableView = tableViewSpy
        
        // When
        let displayedMovies = [MoviesList.Fetch.ViewModel.DisplayedMovie(title: "Harry Potter", details: "* Date : 18/09/18 - Rating : 2.50")]
        let viewModel = MoviesList.Fetch.ViewModel(displayedMovies: displayedMovies)
        sut.displayFetchedMovies(viewModel: viewModel)
        
        // Then
        XCTAssert(tableViewSpy.reloadDataCalled, "Displaying fetched movies should reload the tableView")
    }
    
    func test_NumberOfSectionsInTableView_ShouldAlwaysBeOne() {
        // Given
        let tableView = sut.tableView
        
        // When
        let numberOfSections = sut.numberOfSections(in: tableView!)
        
        // Then
        XCTAssertEqual(numberOfSections, 1, "The number of table view sections should always be 1")
    }
    
    func test_NumberOfRowsInAnySection_Should_Equal_OfMoviesToDisplay() {
        // Given
        let tableView = sut.tableView
        let displayedMovies = [MoviesList.Fetch.ViewModel.DisplayedMovie(title: "Harry Potter", details: "* Date : 18/09/18 - Rating : 2.50")]
        sut.displayedMovies = displayedMovies
        
        // When
        let numberOfRows = sut.tableView(tableView!, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRows, displayedMovies.count, "The number of table rows should equal the number of movies to display")
    }
    
    func test_ShouldConfigureTableViewCell_ToDisplay_Movie() {
        // Given
        let tableView = sut.tableView
        let displayedMovies = [MoviesList.Fetch.ViewModel.DisplayedMovie(title: "Harry Potter", details: "* Date : 18/09/18 - Rating : 2.50")]
        sut.displayedMovies = displayedMovies
        
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView!, cellForRowAt: indexPath)
        
        // Then
        XCTAssertEqual(cell.textLabel?.text, "Harry Potter", "A properly configured tableViewCell should display the movie title")
        XCTAssertEqual(cell.detailTextLabel?.text, "* Date : 18/09/18 - Rating : 2.50", "A properly configured tableViewCell should display the movie details(date & rating)")
    }
}
