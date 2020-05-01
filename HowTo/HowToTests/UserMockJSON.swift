//
//  UserMockJSON.swift
//  HowToTests
//
//  Created by Tobi Kuyoro on 01/05/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

let validUserJSON = """
{
    "username": "Tobi",
    "password": "password"
}
""".data(using: .utf8)!

let inValidUserJSON = """
{
    "username": 1,
    "password": "password"
}
""".data(using: .utf8)!
