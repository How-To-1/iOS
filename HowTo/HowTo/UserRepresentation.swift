//
//  UserRepresentation.swift
//  HowTo
//
//  Created by Dahna on 4/28/20.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    var username: String
    var password: String
    var isCreator: Bool
    var isRegistered: Bool
}
