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
    
    var structureName = ""
    var structureType = ""
    var placeImage = UIImage()
    
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init(){}
}
