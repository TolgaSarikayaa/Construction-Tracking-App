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
    var selectedPlaceId = [String]()
    
    

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        getDataFromFirestore()

    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userLabel.text = userArray[indexPath.row]
        cell.structureNameLabel.text = placeNameArray[indexPath.row]
        // Burdan dene
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = selectedPlaceId[indexPath.row]
        
        return cell
        
    }
    
    //MARK: - Funtions
    func getDataFromFirestore() {
        
        let FirestoreDatabase = Firestore.firestore()
        
        FirestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userArray.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.selectedPlaceId.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.selectedPlaceId.append(documentID)
                        
                        
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
    
    // Hata aliyoruz
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            
            if let destinationVC = segue.destination as? DetailsVC,
                     let selectedIndex = tableView.indexPathForSelectedRow?.row {
                      destinationVC.choosenPlaceId = [selectedPlaceId[selectedIndex]]
                      destinationVC.choosenImage = userImageArray[selectedIndex]
                      destinationVC.choosenName = placeNameArray[selectedIndex]
                      
                  }
              }
         
             
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    
    
  

    
}
