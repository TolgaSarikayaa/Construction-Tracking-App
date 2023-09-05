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

class PlacesTableViewController: UITableViewController {
    
    var userArray = [String]()
    var placeNameArray = [String]()
    var structureType = [String]()
    var placeIdArray = [String]()
    var userImageArray = [String]()
    var selectedPlaceId = [String]()
    
    let fireStoreDatabase = Firestore.firestore()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        getDataFromFirestore()
         
       getUserInfo()
      
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userLabel.text = userArray[indexPath.row]
        cell.structureNameLabel.text = placeNameArray[indexPath.row]
        
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = selectedPlaceId[indexPath.row]
        
        return cell
        
    }
    
    //MARK: - Funtions
    func getDataFromFirestore() {
        
        
        fireStoreDatabase.collection("Post").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userArray.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.selectedPlaceId.removeAll(keepingCapacity: false)
                    self.structureType.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        
                        self.selectedPlaceId.append(documentID)
                        
                        
                        if let postedBy = document.get("user") as? String {
                            self.userArray.append(postedBy)
                        }
                        
                        if let postComment = document.get("postComment") as? String {
                            self.placeNameArray.append(postComment)
                        }
                        
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                        
                        if let postStructureType = document.get("structureType") as? String {
                            self.structureType.append(postStructureType)
                        }
                        
                    }
                   
                    self.tableView.reloadData()
                  
                }
                
                
                
            }
            
            
        }
        
      
    }
    
    func getUserInfo() {
        
        if let currentUser = Auth.auth().currentUser {
               if let email = currentUser.email {
                   fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: email).getDocuments { (snapshot, error) in
                       if error != nil {
                           self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
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
                   // Handle the case where the email is nil
                   print("User email is nil")
               }
           } else {
               // Handle the case where there is no authenticated user
               print("No authenticated user")
           }

        
    }
    
 
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            
            if let destinationVC = segue.destination as? DetailsVC,
                     let selectedIndex = tableView.indexPathForSelectedRow?.row {
                      destinationVC.choosenPlaceId = [selectedPlaceId[selectedIndex]]
                      destinationVC.choosenImage = userImageArray[selectedIndex]
                      destinationVC.choosenName = placeNameArray[selectedIndex]
                      destinationVC.choosenType = structureType[selectedIndex]
                      
                  }
              }
         
             
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func makeAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    
}
