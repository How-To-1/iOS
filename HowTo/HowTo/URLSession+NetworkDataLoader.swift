//
//  URLSession+NetworkDataLoader.swift
//  HowTo
//
//  Created by Tobi Kuyoro on 01/05/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

extension URLSession: NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: request, completionHandler: completion).resume()
    }

    func loadData(using request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        dataTask(with: request) { data, _, error in
            completion(data, error)
        }.resume()
    }

    func loadData(using request: URLRequest, completion: @escaping (Error?) -> Void) {
        dataTask(with: request) { _, _, error in
            completion(error)
        }.resume()
    }
}
