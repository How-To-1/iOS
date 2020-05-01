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

    func testSigningInExistingUser() {
        let expectation = XCTestExpectation(description: "Waiting for authentication...")
        let userController = UserController()

        let user = UserRepresentation(username: "Tobi", password: "password")

        userController.signIn(user: user) { error, _ in
            if let error = error {
                XCTFail("Error signing in: \(error)")
                return
            }

            XCTAssertNoThrow(user)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testValidTutorialJSON() {
        let dataLoader = MockDataLoader(data: validTutorialJSON, response: nil, error: nil)
        let expectation = XCTestExpectation(description: "Waiting for results...")
        let controller = TutorialController(dataLoader: dataLoader)

        controller.fetchTutorialFromServer { error in
            XCTAssertNil(error)
        }

        expectation.fulfill()

        wait(for: [expectation], timeout: 5)
    }

    func testInvalidTutorialJSON() {
        let dataLoader = MockDataLoader(data: inValidUserJSON, response: nil, error: nil)
        let expectation = XCTestExpectation(description: "Waiting for results...")
        let controller = TutorialController(dataLoader: dataLoader)

        controller.fetchTutorialFromServer { error in
            XCTAssertNotNil(error)
        }

        expectation.fulfill()

        wait(for: [expectation], timeout: 5)
    }

    func testCreatingTutorial() {
        let userExpectation = XCTestExpectation(description: "Signing in user...")
        let tutorialExpectation = XCTestExpectation(description: "Creating tutorial")
        let tutorialController = TutorialController()
        let createController = CreateController()
        let userController = UserController()
        let tutorial = createController.tutorial

        let user = UserRepresentation(username: "Tobi", password: "password")

        userController.signIn(user: user) { error, _ in
            if let error = error {
                XCTFail("Error signing in: \(error)")
                return
            }

            XCTAssertNoThrow(user)
            userExpectation.fulfill()
        }

        guard let bearer = userController.bearer else { return }

        tutorialController.sendTutorialToServer(tutorial: tutorial, bearer: bearer) { error in
            if let error = error {
                XCTFail("Error creating tutorial: \(error)")
                return
            }

            XCTAssertNoThrow(tutorial)
            tutorialExpectation.fulfill()
        }

        wait(for: [tutorialExpectation], timeout: 10)
    }

    func testDecodingTutorials() {
        do {
            let data = validTutorialJSON
            let tutorial = try JSONDecoder().decode(TutorialRepresentation.self, from: data)
            XCTAssertNoThrow(tutorial)
        } catch {
            XCTFail("Error decoding tutorial: \(error)")
        }
    }

    func testDecodingUser() {
        var testUser: UserRepresentation?

        do {
            let data = validUserJSON
            let user = try JSONDecoder().decode(UserRepresentation.self, from: data)
            testUser = user
        } catch {
            XCTFail("Error decoding user: \(error)")
        }

        XCTAssertNotNil(testUser)
    }

    func testDecodingInvalidUser() {
        do {
            let data = inValidUserJSON
            let user = try JSONDecoder().decode(UserRepresentation.self, from: data)
            XCTAssertThrowsError(user)
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
