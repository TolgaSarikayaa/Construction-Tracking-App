//
//  ProblemFeedTableViewController.swift
//  Red
//
//  Created by Tolga Sarikaya on 09.09.23.
//

import UIKit
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage
import SDWebImage
import FirebaseAuth

class ProblemFeedTableViewController: UITableViewController {

    var problemArray = [Problem]()
    var choosenProblem : Problem?
    
    
    
    let fireStoreDatabase = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        getProblemsFromFirebase()
      
    }

    // MARK: - Table view data source
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    return problemArray.count
    }
    
    func getProblemsFromFirebase() {
        fireStoreDatabase.collection("Problems").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                _ = UIAlertController.Alert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty != true {
                    self.problemArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        //let documentId = document.documentID
                        
                        if let problemPerson = document.get("person") as? String {
                            if let imageUrlArray = document.get("image") as? String {
                                if let mistake = document.get("mistake") as? String {
                                    
                                        
                                        
                                        let problem = Problem(projectEngineer: problemPerson, problemImage: imageUrlArray, problemExplain: mistake)
                                        self.problemArray.append(problem)
                                   
                                }
                            }
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProblemCell
        cell.projectPersonLabel.text = "Engineer: \(problemArray[indexPath.row].projectEngineer)"
        cell.problemLabel.text = "Problem: \(problemArray[indexPath.row].problemExplain)"
        cell.problemImageView.sd_setImage(with: URL(string: problemArray[indexPath.row].problemImage))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                cell.backgroundColor = .systemBackground
            } else {
                cell.accessoryType = .checkmark
                cell.backgroundColor = .systemGreen
            }
        }
        
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let storage = Storage.storage()
       // let storageRef = storage.reference()
        
        
        if editingStyle == .delete {
            
        }
    }
    

}
