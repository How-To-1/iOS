//
//  TutorialDetailViewController.swift
//  HowTo
//
//  Created by Tobi Kuyoro on 30/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class TutorialDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var tutorial: Tutorial?
    var tutorialController: TutorialController?
    var userController: UserController?
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var guideTextView: UITextView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Actions

    func updateViews() {
        guard let tutorial = tutorial,
            let category = tutorial.category,
            let userController = userController else { return }

        titleLabel.text = tutorial.title
        guideTextView.text = tutorial.guide
        imageView.image = UIImage(named: category)
        
        if userController.bearer == nil {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem = self.editButton
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEditTutorialSegue" {
            if let destinationVC = segue.destination as? CreateTutorialViewController {
                destinationVC.tutorialController = tutorialController
                destinationVC.userController = userController
                if let tutorial = tutorial {
                    destinationVC.tutorial = tutorial
                }
            }
        }
    }
}

