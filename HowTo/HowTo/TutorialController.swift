//
//  TutorialController.swift
//  HowTo
//
//  Created by Dahna on 4/28/20.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

let baseURL = URL(string: "https://how-to-guide-unit4-build.herokuapp.com/")!

class TutorialController {
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    init() {
        
    }
    
    func fetchTutorialFromServer(completion: @escaping CompletionHandler = { _ in
        }) {
        let requestURL = baseURL.appendingPathComponent("api/guides")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error fetching tutorials: \(error)")
                completion(.failure(.otherError))
                return
            }
            guard let data = data else {
                NSLog("No data returned from fetch")
                completion(.failure(.noData))
                return
            }
            do {
                let tutorialRepresentations = Array(try JSONDecoder().decode([String: TutorialRepresentation].self, from: data).values)
                try self.updateTutorials(with: tutorialRepresentations)
                completion(.success(true))
            } catch {
                NSLog("Error decoding tutorials from server: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
    func sendTutorialToServer(tutorial: Tutorial, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("api/guides")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        guard let representation = tutorial.tutorialRepresentation else {
            NSLog("Tutorial Representation is nil")
            completion(.failure(.noRep))
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding tutorial \(tutorial): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error sending tutorial to server: \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
    }
    
    func deleteTaskFromServer(tutorial: Tutorial, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("api/guides")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error deleting tutorial from server: \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
    }
    
    private func updateTutorials(with representations: [TutorialRepresentation]) throws {
        
    }
    
}
