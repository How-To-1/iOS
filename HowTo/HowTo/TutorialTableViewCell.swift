//
//  TutorialTableViewCell.swift
//  HowTo
//
//  Created by Tobi Kuyoro on 30/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class TutorialTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    static let reuseIdentifier = "TutorialCell"
    
    var tutorial: Tutorial? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let tutorial = tutorial,
            let categoryString = tutorial.category,
            let category = Category(rawValue: categoryString) else { return }
        
        categoryLabel.text = tutorial.category
        titleLabel.text = tutorial.title
        
        switch category {
        case .automotive:
            categoryImage.image = UIImage(named: "Automotive")
        case .computing:
            categoryImage.image = UIImage(named: "Computing")
        case .food:
            categoryImage.image = UIImage(named: "Food")
        default:
            categoryImage.image = UIImage(named: "Home")
        }
    }

}
