//
//  TutorialRepresentation.swift
//  HowTo
//
//  Created by Dahna on 4/28/20.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

struct TutorialRepresentation: Codable {
    var title: String
    var guide: String
    var category: String
    var identifier: UUID
}
