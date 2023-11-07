//
//  ProblemModel.swift
//  Red
//
//  Created by Tolga Sarikaya on 09.09.23.
//

import Foundation
import UIKit

class Problem {
    var projectEngineer: String?
    var problemImage : String?
    var problemExplain : String?
    var documentId : String?
    
    init() {
        
    }
    
    init(projectEngineer: String, problemImage: String, problemExplain: String, documentId: String) {
        self.projectEngineer = projectEngineer
        self.problemImage = problemImage
        self.problemExplain = problemExplain
        self.documentId = documentId
    }
}
