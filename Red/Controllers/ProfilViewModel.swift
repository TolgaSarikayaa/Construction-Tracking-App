//
//  ProfilViewModel.swift
//  Red
//
//  Created by Tolga Sarikaya on 25.11.23.
//

import Foundation
import RxSwift
import FirebaseAuth

class ProfilViewModel {
    var userRepo = ProfileRepository()
    var userList = BehaviorSubject<[User]>(value: [User]())
    
    init() {
        userList = userRepo.userList
        getUser()
    }
    
    func getUser() {
        if let currentUserUID = Auth.auth().currentUser?.uid {
                    userRepo.getData(forUID: currentUserUID)
        }
    }
    
}
