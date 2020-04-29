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
        guard let title = titleTextField.text,
            let categoryString = categoryTextField.text,
            let category = Category(rawValue: categoryString),
            let guide = textView.text else { return }

        let dateNow = Date()
        let timeInterval = dateNow.timeIntervalSince1970
        let identifier = Int16(timeInterval)

        let tutorial = Tutorial(title: title, guide: guide, category: category, identifier: identifier)
        tutorialController?.sendTutorialToServer(tutorial: tutorial)

        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Actions


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
