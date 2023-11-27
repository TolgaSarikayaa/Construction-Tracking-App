//
//  User.swift
//  Red
//
//  Created by Tolga Sarikaya on 25.11.23.
//

import Foundation

class User  {
    static let sharedinstance = User()
    
    var company: String?
    var username: String?
    var email: String?
    var profileImageURL: String?
    var documentId: String?
    
    init() {
        
    }
    
    init(company: String, username: String, email: String, profileImageURL: String, documentId: String) {
        self.company = company
        self.username = username
        self.email = email
        self.profileImageURL = profileImageURL
        self.documentId = documentId
    }
}
