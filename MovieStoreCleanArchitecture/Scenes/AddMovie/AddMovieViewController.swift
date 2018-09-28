//
//  AddMovieViewController.swift
//  MovieStoreCleanArchitecture
//
//  Created by Achraf TRABELSI on 17/09/2018.
//  Copyright (c) 2018 Achraf TRABELSI. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AddMovieDisplayLogic: class {
    func displayAddMovie(viewModel: AddMovie.Add.ViewModel)
}

class AddMovieViewController: UIViewController, AddMovieDisplayLogic {
    
    var interactor: AddMovieBusinessLogic?
    var router: (NSObjectProtocol & AddMovieRoutingLogic & AddMovieDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = AddMovieInteractor()
        let presenter = AddMoviePresenter()
        let router = AddMovieRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Add movie
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var producerTextField: UITextField!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var releaseDatePicker: UIDatePicker!
    @IBOutlet weak var ratingSlider: UISlider!

    @IBAction func saveMovieButtonDidClicked(_ sender: UIButton) {
        
        let title = titleTextField.text!
        let producer = producerTextField.text!
        let overview = overviewTextView.text!
        let releaseDate = releaseDatePicker.date.timeIntervalSince1970
        let rating = ratingSlider.value
        
        let request = AddMovie.Add.Request(movieFromFields: Movie(id: nil, title: title, overview: overview, releaseDate: UInt64(releaseDate), rating: Double(rating), producer: producer))
        
        interactor?.addMovie(request: request)
    }
    
    func displayAddMovie(viewModel: AddMovie.Add.ViewModel) {
        if viewModel.movie != nil {
            router?.popViewController(self.navigationController!)
            // router?.routeToListOrders(segue: nil)
        } else {
            showOrderFailureAlert(title: "Failed to create movie", message: "Please correct your movie and submit again.")
        }
    }
    
    private func showOrderFailureAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        showDetailViewController(alertController, sender: nil)
    }
}
