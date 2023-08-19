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

class PlacesTableViewController: UITableViewController {
    
    var userArray = [String]()
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var userImageArray = [String]()
    var selectedPlaceId = ""
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        getDataFromFirestore()

    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userLabel.text = userArray[indexPath.row]
        cell.structureNameLabel.text = placeNameArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        return cell
        
    }
    
    //MARK: - Funtions
    func getDataFromFirestore() {
        
        let FirestoreDatabase = Firestore.firestore()
        
        FirestoreDatabase.collection("Posts").addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userArray.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userArray.append(postedBy)
                        }
                        
                        if let postComment = document.get("postComment") as? String {
                            self.placeNameArray.append(postComment)
                        }
                        
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                    }
                   
                    self.tableView.reloadData()
                }
                
            }
        }
        
        
        
        
    }
    
  

    
}
