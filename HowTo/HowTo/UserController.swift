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

    let baseURL = URL(string: "https://how-to-guide-unit4-build.herokuapp.com/")!

    typealias CompletionHandler = (NetworkError?) -> Void

    func register(user: UserRepresentation, completion: @escaping CompletionHandler) {
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
}
