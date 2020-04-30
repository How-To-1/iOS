//
//  HomeScreenTableViewController.swift
//  HowTo
//
//  Created by Tobi Kuyoro on 29/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import CoreData

class HomeScreenTableViewController: UITableViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Properties

    var frc = NSFetchedResultsController<Tutorial>()
    
    let userController = UserController()
    let tutorialController = TutorialController()

    // MARK: - Actions

    @IBAction func addButtonTapped(_ sender: Any) {
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupFRC()
        
        if userController.bearer == nil {
            self.navigationItem.leftBarButtonItem = nil
        } else {
            self.navigationItem.leftBarButtonItem = self.signOutButton
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let objects = frc.fetchedObjects else { return 0 }
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: TutorialTableViewCell.reuseIdentifier, for: indexPath) as? TutorialTableViewCell else {
            fatalError("Can't dequeue cell of type TutorialCell")
        }
         
        cell.tutorial = frc.object(at: indexPath)

        return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tutorial = frc.object(at: indexPath)
            tutorialController.deleteTutorialFromServer(tutorial: tutorial)
            tutorialController.delete(tutorial: tutorial)
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateTutorialSegue" {
            if let destinationVC = segue.destination as? CreateTutorialViewController {
                destinationVC.userController = userController
                destinationVC.tutorialController = tutorialController
            }
        }

        else if segue.identifier == "ShowTutorialDetailSegue" {

        }
    }
    
    // MARK: - Private Functions
    
    func setupFRC() {
        let request: NSFetchRequest<Tutorial> = Tutorial.fetchRequest()
        // filter what we want from CoreData
        if searchBar.text != "" {
            request.predicate = NSPredicate(format: "title CONTAINS[c] %@", searchBar.text ?? "")
        }
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: moc,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("could not fetch: \(error)")
        }
        frc = fetchedResultsController
        tableView.reloadData()
    }
}

extension HomeScreenTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        setupFRC()
    }
}
