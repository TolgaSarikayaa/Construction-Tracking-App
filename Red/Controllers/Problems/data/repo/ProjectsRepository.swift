//
//  ProjectsRepository.swift
//  Red
//
//  Created by Tolga Sarikaya on 10.11.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import RxSwift

class ProjectsRepository {
    var projectList = BehaviorSubject<[PlaceModel]>(value: [PlaceModel]())
    var collectionProjects = Firestore.firestore()
    
    func getProjects() {
        var list = [PlaceModel]()
       
        
        collectionProjects.collection("Post").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty != true {
                    list.removeAll(keepingCapacity: false)
                   
                    if let documents = snapshot?.documents {
                        for document in documents {
                            let data = document.data()
                            
                            let id = document.documentID
                            let engineer = data["Engineer"] as? String ?? ""
                            let projectName = data["structurName"] as? String ?? ""
                            let imageUrl = data["imageUrl"] as? String ?? ""
                            let structureType = data["structureType"] as? String ?? ""
                            let budget = data["Budget"] as? String ?? ""
                            let Latitude = data["placelatitude"] as? String ?? ""
                            let Longitude = data["placeLongitude"] as? String ?? ""
                            //let projectLatitude = Double(Latitude)
                            //let projectLongitude = Double(Longitude)
                            
                            let project = PlaceModel(structureName: projectName, structureType: structureType, engineer: engineer, budget: budget, imageUrl: imageUrl, documentId: id, placeLatitude: Latitude, placeLongitude: Longitude)
                            list.append(project)
                        }
                    }
                    
                    self.projectList.onNext(list)
                }
            }
        }
        
    }
    
    func getUserInfo() {
        if let currentUser = Auth.auth().currentUser {
            if let email = currentUser.email {
                collectionProjects.collection("UserInfo").whereField("email",
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
    
}
