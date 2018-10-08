//
//  AppDelegate.swift
//  MovieStoreCleanArchitecture
//
//  Created by Achraf TRABELSI on 17/09/2018.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        startStubbing()
        
        return true
    }
    
    func startStubbing() {
        guard let url = URL(string: Constants.Paths.fetchMovies) else { return }
        StubServer.setup(stubServer: MockServer.FetchMovies, url: url, httpMethod: .GET)
        StubServer.start()
    }
}

