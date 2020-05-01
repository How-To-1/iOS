//
//  MockDataLoader.swift
//  HowToTests
//
//  Created by Tobi Kuyoro on 01/05/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
@testable import HowTo

class MockDataLoader: NetworkDataLoader {

    let data: Data?
    let response: URLResponse?
    let error: Error?

    internal init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            completion(self.data, self.response, self.error)
        }
    }
}
