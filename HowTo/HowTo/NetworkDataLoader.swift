//
//  NetworkDataLoader.swift
//  HowTo
//
//  Created by Tobi Kuyoro on 01/05/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

protocol NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping(Data?, URLResponse?, Error?) -> Void)
    func loadData(using request: URLRequest, completion: @escaping(Data?, Error?) -> Void)
    func loadData(using request: URLRequest, completion: @escaping(Error?) -> Void)
}
