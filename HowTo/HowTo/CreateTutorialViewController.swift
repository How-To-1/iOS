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
    @IBOutlet weak var hintsTextView: UITextView!

    // MARK: - Properties

    var tutorialController: TutorialController?
    var userController: UserController?
    var selectedCategory: String?
    let categories = ["Automotive", "Computing", "Food", "Home"]

    var tutorial: Tutorial? {
        didSet {
            updateViews()
        }
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        udpdateTextView()
        createTapGesture()
        createCategoryPicker()
        textViewWithTutorial()

        hintsTextView.delegate = self
        
        if let _ = tutorial {
            updateViews()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let userController = userController else { return }

        if userController.bearer == nil {
            performSegue(withIdentifier: "ModalOnboardingSegue", sender: self)
        }
    }

    // MARK: - IBActions

    @IBAction func saveButtonTapped(_ sender: Any) {
        if let tutorial = tutorial {
          guard let title = titleTextField.text,
          let categoryString = categoryTextField.text,
          let category = Category(rawValue: categoryString),
          let guide = hintsTextView.text else { return }
            tutorialController?.update(tutorial: tutorial, title: title, guide: guide, category: category.rawValue, identifier: tutorial.identifier)
        } else {
          guard let title = titleTextField.text,
            let categoryString = categoryTextField.text,
            let category = Category(rawValue: categoryString),
            let guide = hintsTextView.text else { return }
          let identifier = Int64.random(in: 100...1_000)
          let tutorial = Tutorial(title: title, guide: guide, category: category, identifier: identifier)
          tutorialController?.sendTutorialToServer(tutorial: tutorial)
        }
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Actions

    private func updateViews() {
        guard isViewLoaded else { return }
        if let tutorial = tutorial {
            titleTextField.text = tutorial.title
            categoryTextField.text = tutorial.category
            hintsTextView.text = tutorial.guide
        }
    }

    private func udpdateTextView() {
        hintsTextView.text = "Some Helpful Hints:\n\nTry to provide a step by step guide on this topic."
        hintsTextView.textColor = .lightGray
        hintsTextView.backgroundColor = .white
        hintsTextView.layer.borderWidth = 0.5
        hintsTextView.layer.cornerRadius = 10
        hintsTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func textViewWithTutorial() {
      if let tutorial = tutorial {
        hintsTextView.text = tutorial.guide
        hintsTextView.textColor = .black
        hintsTextView.backgroundColor = .white
        hintsTextView.layer.borderWidth = 0.5
        hintsTextView.layer.cornerRadius = 10
        hintsTextView.layer.borderColor = UIColor.lightGray.cgColor
      }
    }

    private func createCategoryPicker() {
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.backgroundColor = .white
        categoryTextField.inputView = categoryPicker
    }

    private func createTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalOnboardingSegue" {
            if let destinationVC = segue.destination as? OnboardingViewController {
                destinationVC.userController = userController
            }
        }
    }
}

extension CreateTutorialViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
        categoryTextField.text = selectedCategory
    }
}

extension CreateTutorialViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Some Helpful Hints:\n\nTry to provide a step by step guide on this topic."
            textView.textColor = UIColor.lightGray
        }
    }
}
