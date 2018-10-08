//
//  MockServer.swift
//  MovieStoreCleanArchitecture
//
//  Created by Achraf TRABELSI on 03/10/2018.
//  Copyright © 2018 Achraf TRABELSI. All rights reserved.
//

import Foundation
import Hippolyte

enum StubServerError: Error {
    case fileNotFound
    case buildDataFailed
}

enum StubHTTPMethod: String {
    case GET, POST
}

protocol StubServerProtocol {
    /// Bundle where file is located.
    var bundle: Bundle { get }
    
    /// Specifies parameters name matching with url.
    var parameters: [String]? { get }
    
    // Specifies status code. Default is 200.
    var statusCode: Int { get }
    
    // Specifies the name of stub file used.
    func stubFile() -> String
}

extension StubServerProtocol {
    var bundle: Bundle { return Bundle.main }
    
    var parameters: [String]? { return nil }
    
    var statusCode: Int { return 200 }
    
    func stubFile() throws -> Data {
        let name = self.stubFile()
        
        if let path = bundle.path(forResource: String(name), ofType: "json") {
            do {
                return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            } catch {
                throw StubServerError.buildDataFailed
            }
        } else {
            throw StubServerError.fileNotFound
        }
    }
}

struct StubServer {
    static func setup(stubServer: StubServerProtocol..., url: URL, httpMethod: StubHTTPMethod = .GET) {
        var stub = StubRequest(method: HTTPMethod(rawValue: httpMethod.rawValue)!, url: url)
        var response = StubResponse()
        do {
            let data = try stubServer.first!.stubFile() as Data // To refactor
            response.body = data
            stub.response = response
            Hippolyte.shared.add(stubbedRequest: stub)
            
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    static func start() {
        Hippolyte.shared.start()
    }
    
    static func stop() {
        Hippolyte.shared.stop()
    }
}

enum MockServer: StubServerProtocol {
    case FetchMovies
    
    var bundle: Bundle { return Bundle.main }
    
    var statusCode: Int { return 200 }
    
    func stubFile() -> String {
        switch self {
            case .FetchMovies:
            return "Movies"
        }
    }
}
