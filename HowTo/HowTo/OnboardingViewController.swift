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
            signIn(with: user)
        } else {
            register(user: user)
        }
    }

    @IBAction func smallButtonTapped(_ sender: UIButton) {
        isLoggedIn.toggle()

        if isLoggedIn == false {
            signInButton.setTitle("SIGN IN", for: .normal)
            accountLabel.text = "Don't have an account?"
            signInButtonLabel.setTitle("Register", for: .normal)
            state = .notLoggedIn
        } else {
            signInButton.setTitle("SIGN UP", for: .normal)
            accountLabel.text = "Already have an account?"
            signInButtonLabel.setTitle("Sign In", for: .normal)
            state = .loggedIn
        }
    }

    // MARK: - Actions

    private func signIn(with user: UserRepresentation) {
        userController?.signIn(user: user, completion: { error, _ in
            if let error = error {
                NSLog("Error signing in with provided details: \(error)")
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
            }

            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }

    private func updateViews() {

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
