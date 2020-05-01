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
    
    let userController = UserController()
    let tutorialController = TutorialController()

    lazy var fetchedResultsController: NSFetchedResultsController<Tutorial> = {
        let fetchRequest: NSFetchRequest<Tutorial> = Tutorial.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: "title",
                                             cacheName: nil)
        frc.delegate = self

        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch:\(error)")
        }

        return frc
    }()

    // MARK: - Actions

    @IBAction func addButtonTapped(_ sender: Any) {
    }

    func titleView() {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 40))
        label.backgroundColor = .clear
        label.font = UIFont(name: "Play-Bold", size: 22)

        label.text = "Guides"
        label.numberOfLines = 2
        label.textColor = .black
        label.sizeToFit()
        label.textAlignment = .center

        self.navigationItem.titleView = label
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        titleView()
        
        if userController.bearer == nil {
            self.navigationItem.leftBarButtonItem = nil
        } else {
            self.navigationItem.leftBarButtonItem = self.signOutButton
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      return fetchedResultsController.sections?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "TutorialCell", for: indexPath) as? TutorialTableViewCell else { return UITableViewCell() }
      let tutorial = fetchedResultsController.object(at: indexPath)
      cell.tutorial = tutorial
      return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tutorial = fetchedResultsController.object(at: indexPath)
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
        } else if segue.identifier == "ShowTutorialDetailSegue" {
            if let destinationVC = segue.destination as? TutorialDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.tutorialController = tutorialController
                destinationVC.tutorial = fetchedResultsController.object(at: indexPath)
                destinationVC.userController = userController
            }
        }
    }
    
}

extension HomeScreenTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {

        let sectionSet = IndexSet(integer: sectionIndex)

        switch type {
        case .insert:
            tableView.insertSections(sectionSet, with: .automatic)
        case .delete:
            tableView.deleteSections(sectionSet, with: .automatic)
        default:
            return
        }
    }
}

extension HomeScreenTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     
    }
}
