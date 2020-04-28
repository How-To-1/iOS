//
//  Tutorial+Convenience.swift
//  HowTo
//
//  Created by Tobi Kuyoro on 28/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import CoreData

enum Category: String, CaseIterable {
    case automotive = "Automotive"
    case computing = "Computing"
    case home = "Home"
    case food = "Food"
}

extension Tutorial {
    var tutorialRepresentation: TutorialRepresentation? {
        guard let title = title,
            let guide = guide,
            let category = category,
            let identifier = identifier else { return nil }

        return TutorialRepresentation(title: title, guide: guide, category: category, identifier: identifier)
    }

    @discardableResult convenience init(title: String,
                                        guide: String,
                                        category: Category,
                                        identifier: UUID = UUID(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.guide = guide
        self.category = category.rawValue
        self.identifier = identifier
    }

    @discardableResult convenience init?(tutorialRepresentation: TutorialRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let category = Category(rawValue: tutorialRepresentation.category) else { return nil }

        self.init(title: tutorialRepresentation.title,
                  guide: tutorialRepresentation.guide,
                  category: category,
                  context: context)
    }
}
