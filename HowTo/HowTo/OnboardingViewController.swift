//
//  OnboardingViewController.swift
//  HowTo
//
//  Created by Tobi Kuyoro on 30/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

enum LogInState {
    case loggedIn
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

    // MARK: - IBActions

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty, !password.isEmpty else { return }

        let user = UserRepresentation(username: username, password: password)

        if state == .notLoggedIn {
            // This should sign in
        } else {
            // This should register
        }
    }

    @IBAction func smallButtonTapped(_ sender: UIButton) {
        isLoggedIn.toggle()
    }

    // MARK: - Actions

    private func signIn(with user: UserRepresentation) {

    }

    private func register(user: UserRepresentation) {

    }

    private func updateViews() {
        if isLoggedIn == false {
            signInButton.setTitle("Sign In", for: .normal)
            accountLabel.text = "Don't have an account?"
            signInButtonLabel.setTitle("Register", for: .normal)
            state = .notLoggedIn
        } else {
            signInButton.setTitle("Sign Up", for: .normal)
            accountLabel.text = "Already have an account?"
            signInButtonLabel.setTitle("Sign In", for: .normal)
            state = .loggedIn
        }
    }

    private func updateTextFields() {
        OnboardingTextField.styleTextField(usernameTextField)
        OnboardingTextField.styleTextField(passwordTextField)
        passwordTextField.isSecureTextEntry = true
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextFields()
        updateViews()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
