//
//  User+Convenience.swift
//  HowTo
//
//  Created by Tobi Kuyoro on 29/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import CoreData

extension User {
    var userRepresentation: UserRepresentation? {
        guard let email = email,
            let password = password else { return nil }

        return UserRepresentation(email: email, password: password, isCreator: isCreator, isRegistered: isRegistered)
    }

    @discardableResult convenience init(email: String,
                                        password: String,
                                        isCreator: Bool = false,
                                        isRegistered: Bool = false,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.email = email
        self.password = password
        self.isCreator = isCreator
        self.isRegistered = isRegistered
    }

    @discardableResult convenience init?(userRepresentation: UserRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(email: userRepresentation.email,
                  password: userRepresentation.password,
                  context: context)
    }
}
