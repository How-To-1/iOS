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
    var category: String?
    var identifier: Int64
    
    enum CodingKeys: String, CodingKey {
        case title
        case guide = "description"
        case category
        case identifier = "guides_id"
    }
}

