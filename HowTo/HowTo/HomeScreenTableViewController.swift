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
        
        // TESTING CODE REFERENCE
//        let testTut = Tutorial(title: "mango", guide: "testguide", category: Category.automotive, identifier: Int16(12), context: CoreDataStack.shared.mainContext)
//        print(testTut)
//        CoreDataStack.shared.save()
//
//        let fetchRequest = NSFetchRequest<Tutorial>(entityName: "Tutorial")
//        do {
//            let fetchedResults = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
//            for item in fetchedResults {
//                print(item.value(forKey: "title")!)
//            }
//        } catch let error as NSError {
//            // something went wrong, print the error.
//            print(error.description)
//        }
        
        setupFRC()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let objects = frc.fetchedObjects else { return 0 }
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorialCell", for: indexPath)

        // Configure the cell...

        return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

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
