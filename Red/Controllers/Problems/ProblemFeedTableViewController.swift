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
    
    // MARK: - Properties
    var problemArray = [Problem]()
    var choosenProblem : Problem?
    var selectedProblem : Problem?
    let fireStoreDatabase = Firestore.firestore()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemRed
            navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(addButton))
        
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        
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
                    if let documents = snapshot?.documents {
                        for document in documents {
                           
                            let data = document.data()
                            if let problemPerson = data["person"] as? String {
                                if let imageUrlArray = data["image"]  as? String {
                                    if let mistake = data["mistake"] as? String {
                                        
                                        let problem = Problem(projectEngineer: problemPerson, problemImage: imageUrlArray, problemExplain: mistake, documentId: document.documentID)
                                        self.problemArray.append(problem)
                                    }
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
        cell.projectPersonLabel.text = "Engineer: \(problemArray[indexPath.row].projectEngineer!)"
        cell.problemLabel.text = "Problem: \(problemArray[indexPath.row].problemExplain!)"
        cell.problemImageView.sd_setImage(with: URL(string: problemArray[indexPath.row].problemImage!))
        cell.documentIdLabel.text = choosenProblem?.documentId
        
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cell.cellBackground.layer.cornerRadius = 12.0
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath)  {
         
         if cell.accessoryType == .checkmark {
         cell.accessoryType = .none
         //cell.backgroundColor = .systemBackground
         } else {
         cell.accessoryType = .checkmark
            // cell.backgroundColor = .systemGreen
        }
      }
    }
        override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
                let documentIdToDelete = problemArray[indexPath.row].documentId
                
                fireStoreDatabase.collection("Problems").document(documentIdToDelete!).delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("data deleted successfuly")
                        
                        if let selectedIndexPath = tableView.indexPathForSelectedRow {
                            
                            if selectedIndexPath.row < self.problemArray.count {
                                self.problemArray.remove(at: selectedIndexPath.row)
                                tableView.deleteRows(at: [indexPath], with: .fade)
                                tableView.reloadData()
                            } else {
                                print("invalid index")
                            }
                        }
                    }
                }
            }
        }
    // MARK: - Actions
    @objc func addButton() {
        performSegue(withIdentifier: "toProblem", sender: nil)
    }
}
