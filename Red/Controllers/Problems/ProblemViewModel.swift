//
//  ProblemViewModel.swift
//  Red
//
//  Created by Tolga Sarikaya on 10.11.23.
//

import Foundation
import RxSwift

class ProblemViewModel {
    var problemRepo = ProblemDaoRepository()
    var problemsList = BehaviorSubject<[Problem]>(value: [Problem]())
    
    init() {
        problemsList = problemRepo.problemList
        getProblems()
    }
    
    
    func getProblems() {
        problemRepo.getProblems()
    }
    
    func deleteProject(documentID: String) {
        problemRepo.deleteProject(documentID: documentID)
    }
    
}
