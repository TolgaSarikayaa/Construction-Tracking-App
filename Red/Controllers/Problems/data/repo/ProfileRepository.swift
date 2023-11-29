//
//  ProfileRepository.swift
//  Red
//
//  Created by Tolga Sarikaya on 25.11.23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import RxSwift

class ProfileRepository {
    var userList = BehaviorSubject<[User]>(value: [User]())
    var collectionProjects = Firestore.firestore()
    
    func getData(forUID uid: String) {
        var list = [User]()

        collectionProjects.collection("UserInfo").document(uid).getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let document = document, document.exists {
                let data = document.data()

                let id = document.documentID
                let image = data?["profileImageURL"] as? String ?? ""
                let userName = data?["username"] as? String ?? ""
                let company = data?["company"] as? String ?? ""
                let email = data?["email"] as? String ?? ""

                let user = User(company: company, username: userName, email: email, profileImageURL: image, documentId: id)
                list.append(user)

                self.userList.onNext(list)
            } else {
                print("Document does not exist")
            }
        }
    }

    }

    
    

