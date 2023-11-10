//
//  PlacesTableViewController.swift
//  Red
//
//  Created by Tolga Sarikaya on 12.07.23.
//

import UIKit
import FirebaseFirestore
import FirebaseDatabase
import SDWebImage
import FirebaseAuth
import FirebaseStorage

class PlacesTableViewController: UITableViewController {
    
    // MARK: - UI Elements
    var projects = [PlaceModel]()
    var viewModel = PlacesViewModel()
    var viewModel2 = ProjectsRepository()
   
    let fireStoreDatabase = Firestore.firestore()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = viewModel.projectsList.subscribe(onNext: { list in
            self.projects = list
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = projects[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userLabel.text = "Enginner: \(project.engineer!)"
        cell.structureNameLabel.text = "Project \(project.structureName!)"
        cell.structureTypeLabel.text = "\(project.structureType!)"
        cell.userImageView.sd_setImage(with: URL(string: project.imageUrl!))
        cell.documentIdLabel.text = project.documentId
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cell.cellBackground.layer.cornerRadius = 12.0
        return cell
    }
    
    //MARK: - Funtions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = projects[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: project)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            
            if let project = sender as? PlaceModel {
                if let navigationController = segue.destination as? UINavigationController,
                   let destinationVC = navigationController.topViewController as? DetailTableViewController {
                    destinationVC.projectDetail = project
        
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let documentIDToDelete = projects[indexPath.row].documentId!
            
            fireStoreDatabase.collection("Post").document(documentIDToDelete).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Data deleted successfully.")
                    if let selectedIndexPath = tableView.indexPathForSelectedRow {
                        self.projects.remove(at: selectedIndexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        tableView.reloadData()
                    }
                }
            }
        }
    }
}
