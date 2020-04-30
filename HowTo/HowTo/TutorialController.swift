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
        fetchTutorialFromServer()
    }

    // MARK: - Networking Methods
    
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
            } catch {
                NSLog("Error decoding tutorials from server: \(error)")
                completion(.failure(.noDecode))
            }
            completion(.success(true))
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
    
    func deleteTutorialFromServer(tutorial: Tutorial, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("api/guides")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error deleting tutorial from server: \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
    }
    
    func updateTutorials(tutorial: Tutorial, completion: @escaping CompletionHandler = { _ in }) {

        let identifier = tutorial.identifier
        
        let requestURL = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("guides")
            .appendingPathComponent("\(identifier)")

        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard let representation = tutorial.tutorialRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding tutorial \(tutorial): \(error)")
            completion(.failure(.otherError))
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
    
    private func updateTutorials(with representations: [TutorialRepresentation]) throws {
        let identifierToFetch = representations.compactMap { $0.identifier }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifierToFetch, representations))
        var tutorialsToCreate = representationsByID

        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.performAndWait {
            do {
                let fetchRequest: NSFetchRequest<Tutorial> = Tutorial.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id IN %@", identifierToFetch)

                let existingTutorials = try context.fetch(fetchRequest)

                for tutorial in existingTutorials {
                    let identifier = tutorial.identifier
                    guard let representation = representationsByID[identifier] else { continue }
                    tutorial.title = representation.title
                    tutorial.guide = representation.guide
                    tutorial.category = representation.category

                    tutorialsToCreate.removeValue(forKey: identifier)
                }

                for representation in tutorialsToCreate.values {
                    Tutorial(tutorialRepresentation: representation, context: context)
                }

                CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error fetching tutorials from persistent stores: \(error)")
            }
        }
    }

    // MARK: - CRUD
    
    func createTutorial(title: String, guide: String, category: String, identifier: Int16) {
        guard let categoryRaw = Category(rawValue: category) else { return }
        
        let tutorial = Tutorial(title: title, guide: guide, category: categoryRaw, identifier: identifier)
        
        sendTutorialToServer(tutorial: tutorial)
        CoreDataStack.shared.save()
    }
    
    func update(tutorial: Tutorial, title: String, guide: String, category: String, identifier: Int16) {
        
        tutorial.title = title
        tutorial.guide = guide
        tutorial.category = category
        tutorial.identifier = identifier
        
        updateTutorials(tutorial: tutorial)
        CoreDataStack.shared.save()
    }
    
    func delete(tutorial: Tutorial) {
        deleteTutorialFromServer(tutorial: tutorial)
        CoreDataStack.shared.mainContext.delete(tutorial)
        CoreDataStack.shared.save()
    }
}
