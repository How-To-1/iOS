//
//  OnboardingViewController.swift
//  HowTo
//
//  Created by Tobi Kuyoro on 30/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

enum LogInState {
    case notRegistered
    case notLoggedIn
}

class OnboardingViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var signInButtonLabel: UIButton!

    // MARK: - Properties

    var userController: UserController?
    var isLoggedIn: Bool = false
    var state: LogInState = .notLoggedIn

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextFields()
        notLoggedInState()
    }

    // MARK: - IBActions

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty, !password.isEmpty else { return }

        let user = UserRepresentation(username: username, password: password)

        if state == .notLoggedIn {
            signIn(with: user)
        } else {
            register(user: user)
        }
    }

    @IBAction func smallButtonTapped(_ sender: UIButton) {
        isLoggedIn.toggle()

        if isLoggedIn == false {
            notLoggedInState()
        } else {
            notRegisteredState()
        }
    }

    // MARK: - Actions

    private func signIn(with user: UserRepresentation) {
        userController?.signIn(user: user, completion: { error, _ in
            if let error = error {
                NSLog("Error signing in with provided details: \(error)")
                let alert = UIAlertController(title: "Error",
                                              message: "Please provide valid details",
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)

                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }

            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }

    private func register(user: UserRepresentation) {
        userController?.register(user: user, completion: { error in
            if let error = error {
                NSLog("Error registering new user: \(error)")
                let alert = UIAlertController(title: "Error",
                                              message: "We were unable to create an account with the provided details",
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)

                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }

            let alert = UIAlertController(title: "Success",
                                          message: "We were able to create an account with the provided details",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)

            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
                self.notLoggedInState()
                self.isLoggedIn = false
            }
        })
    }

    private func notLoggedInState() {
        signInButton.setTitle("SIGN IN", for: .normal)
        accountLabel.text = "Don't have an account?"
        signInButtonLabel.setTitle("Register", for: .normal)
        state = .notLoggedIn
    }

    private func notRegisteredState() {
        signInButton.setTitle("SIGN UP", for: .normal)
        accountLabel.text = "Already have an account?"
        signInButtonLabel.setTitle("Sign In", for: .normal)
        state = .notRegistered
    }

    private func updateTextFields() {
        OnboardingTextField.styleTextField(usernameTextField)
        OnboardingTextField.styleTextField(passwordTextField)
        passwordTextField.isSecureTextEntry = true
    }
}
