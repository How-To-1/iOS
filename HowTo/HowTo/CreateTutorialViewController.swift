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
        updateViews()
        udpdateTextView()
        createTapGesture()
        createCategoryPicker()
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

    private func updateViews() {
        if let tutorial = tutorial {
            titleTextField.text = tutorial.title
            categoryTextField.text = tutorial.category
            textView.text = tutorial.guide
        }
    }

    private func udpdateTextView() {
        textView.text = "Suggest some helpful hints..."
        textView.textColor = .gray
        textView.layer.borderWidth = 0.5
    }

    private func createCategoryPicker() {
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.backgroundColor = .clear
        categoryTextField.inputView = categoryPicker
    }

    private func createTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
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
        textView.layer.borderColor = UIColor.darkGray.cgColor

        if textView.textColor == UIColor.gray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.clear.cgColor

        if textView.text.isEmpty {
            textView.text = "Suggest some helpful hints..."
            textView.textColor = UIColor.lightGray
        }
    }
}
