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
    var userArray = [String]()
    var placeNameArray = [String]()
    var structureType = [String]()
    var placeIdArray = [String]()
    var userImageArray = [String]()
    var selectedPlaceId = [String]()
    //var engineer = [String]()
    let fireStoreDatabase = Firestore.firestore()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        
        getDataFromFirestore()
        
        getUserInfo()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userLabel.text = "Enginner: \(projects[indexPath.row].engineer!)"
        cell.structureNameLabel.text = "Project \(projects[indexPath.row].structureName!)"
        cell.structureTypeLabel.text =  "\(projects[indexPath.row].structureType!)"
        cell.userImageView.sd_setImage(with: URL(string: self.projects[indexPath.row].imageUrl!))
        cell.documentIdLabel.text = selectedPlaceId[indexPath.row]
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cell.cellBackground.layer.cornerRadius = 12.0
        return cell
    }
    
    //MARK: - Funtions
    func getDataFromFirestore() {
        fireStoreDatabase.collection("Post").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                _ = UIAlertController.Alert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty != true {
                    self.projects.removeAll(keepingCapacity: false)
                    if let documents = snapshot?.documents {
                        for document in documents {
                            let data = document.data()
                            
                            
                            
                                let documentID = document.documentID
                                self.selectedPlaceId.append(documentID)
                                
                                if let postedBy = data["Engineer"] as? String {
                                    
                                if let postComment = data["structurName"] as? String {
                        
                                if let imageUrl = data["imageUrl"] as? String {
                                
                                    if let postStructureType = data["structureType"] as? String {
                                        
                                        let project = PlaceModel(structureName: postComment, structureType: postStructureType, engineer: postedBy, imageUrl: imageUrl)
                                        self.projects.append(project)
                                        
                                          }
                                       }
                                    }
                                }
                            }
                        }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func getUserInfo() {
        if let currentUser = Auth.auth().currentUser {
            if let email = currentUser.email {
                fireStoreDatabase.collection("UserInfo").whereField("email",
                                                                    isEqualTo: email).getDocuments { (snapshot, error) in
                    if error != nil {
                        _ = UIAlertController.Alert(title: "Error", 
                                                    message: error?.localizedDescription ?? "Error")
                    } else {
                        if let snapshot = snapshot, !snapshot.isEmpty {
                            for document in snapshot.documents {
                                if let username = document.get("username") as? String {
                                    PlaceModel.sharedinstance.email = email
                                    PlaceModel.sharedinstance.username = username
                                }
                            }
                        }
                    }
                }
            } else {
                print("User email is nil")
            }
        } else {
            print("No authenticated user")
        }
    }
    
   
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project1 = projects[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            
            if let project2 = sender as? PlaceModel {
            let destinationVC = segue.destination as! DetailTableViewController
                destinationVC.projectDetail = project2
                destinationVC.choosenLatitude = Double(project2.placeLatitude!)!
                destinationVC.choosenLongitude = Double(project2.placeLongitude!)!
                /*
                destinationVC.choosenName = project.structureName!
                destinationVC.choosenType = project.structureType!
                destinationVC.choosenEnginer = project.engineer!
                destinationVC.choosenBudget = project.budget!
                destinationVC.choosenLatitude = Double(project.placeLatitude!)!
                destinationVC.choosenLongitude = Double(project.placeLongitude!)!
                 */
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let documentIDToDelete = selectedPlaceId[indexPath.row]
            
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
