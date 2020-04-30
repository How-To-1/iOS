//
//  UserController.swift
//  HowTo
//
//  Created by Tobi Kuyoro on 29/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import CoreData

class UserController {

    var bearer: Bearer?
    
    let baseURL = URL(string: "https://how-to-guide-unit4-build.herokuapp.com/")!

    typealias RegisterHandler = (NetworkError?) -> Void
    typealias SignInHandler = (NetworkError?, Bearer?) -> Void

    func register(user: UserRepresentation, completion: @escaping RegisterHandler) {
        let requestURL = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("auth")
            .appendingPathComponent("users")
            .appendingPathComponent("register")

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let userJSON = try JSONEncoder().encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding user: \(error)")
            completion(.noEncode)
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                NSLog("Unexpected status code :\(response.statusCode)")
                completion(.otherError)
                return
            }

            if let error = error {
                NSLog("Error registering new user: \(error)")
                completion(.otherError)
                return
            }

            completion(nil)
        }.resume()
    }
    
    func signIn(user: UserRepresentation, completion: @escaping SignInHandler) {
        let requestURL = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("auth")
            .appendingPathComponent("users")
            .appendingPathComponent("login")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let userJSON = try JSONEncoder().encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding User: \(error)")
            completion(.noEncode, nil)
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                NSLog("Unexpected status code: \(response.statusCode)")
                completion(.otherError, nil)
                return
            }
            guard let data = data else {
                NSLog("Error retrieving data: \(error)")
                completion(.noData, nil)
                return
            }
            
            if let error = error {
                NSLog("Error retrieving user: \(error)")
                completion(.otherError, nil)
                return
            }
            
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                NSLog("Error decoding bearer token: \(error)")
                completion(.noDecode, nil)
            }
            completion(nil, self.bearer)
        }.resume()
    }
}
