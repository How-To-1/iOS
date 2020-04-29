//
//  CreateTutorialViewController.swift
//  HowTo
//
//  Created by Tobi Kuyoro on 29/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class CreateTutorialViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var textView: UITextView!

    // MARK: - Propertis

    var tutorial: Tutorial?
    var tutorialController: TutorialController?
    var selectedCategory: String?
    let categories = ["Automotive", "Computing", "Food", "Home"]

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - IBActions

    @IBAction func saveButtonTapped(_ sender: Any) {

    }

    // MARK: - Actions


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
