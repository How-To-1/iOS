//
//  HowToTests.swift
//  HowToTests
//
//  Created by Tobi Kuyoro on 01/05/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import XCTest
@testable import HowTo

class HowToTests: XCTestCase {

    func testFetchingTutorial() {
        let expectation = XCTestExpectation(description: "Waiting for valid tutorial data...")
        let tutorialController = TutorialController()
        let tutorials = tutorialController.tutorials

        tutorialController.fetchTutorialFromServer { error in
            if let error = error {
                XCTFail("Error during fetch: \(error)")
                return
            }

            XCTAssertNotNil(tutorials)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testRegisterUser() {
        let expectation = XCTestExpectation(description: "Waiting for authentication...")
        let userController = UserController()
        let randomNumber = Int.random(in: 500...1_000)
        let user = UserRepresentation(username: "Tobi\(randomNumber)", password: "password")

        userController.register(user: user) { error in
            if let error = error {
                XCTFail("Error registering user: \(error)")
                return
            }

            XCTAssertNoThrow(user)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testRegisteringUserWithExistingDetails() {
        let expectation = XCTestExpectation(description: "Waiting for authentication...")
        let userController = UserController()

        let user = UserRepresentation(username: "Tobi", password: "password")

        userController.register(user: user) { error in
            if let error = error {
                XCTAssertNotNil(error)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }
}
