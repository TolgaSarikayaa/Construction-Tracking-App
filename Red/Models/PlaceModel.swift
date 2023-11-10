//
//  PlaceModel.swift
//  Red
//
//  Created by Tolga Sarikaya on 12.07.23.
//

import Foundation
import UIKit

class PlaceModel {
    static let sharedinstance = PlaceModel()
    
    var structureName : String?
    var structureType : String?
    var placeImage = UIImage()
    var engineer : String?
    var budget : String?
    var username : String?
    var email : String?
    var imageUrl : String?
    var documentId : String?
    var placeLatitude : String?
    var placeLongitude : String?
    
    
    init() {
        
    }
    
    init(structureName: String? = nil, structureType: String? = nil, placeImage: UIImage = UIImage(), engineer: String? = nil, budget: String? = nil, username: String? = nil, email: String? = nil, imageUrl: String? = nil, documentId: String? = nil, placeLatitude: String? = nil, placeLongitude: String? = nil) {
        self.structureName = structureName
        self.structureType = structureType
        self.placeImage = placeImage
        self.engineer = engineer
        self.budget = budget
        self.username = username
        self.email = email
        self.imageUrl = imageUrl
        self.documentId = documentId
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
    }
    
}
