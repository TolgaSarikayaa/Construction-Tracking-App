//
//  PlacesViewModel.swift
//  Red
//
//  Created by Tolga Sarikaya on 10.11.23.
//

import Foundation
import RxSwift

class PlacesViewModel {
    var projectRepo = ProjectsRepository()
    var projectsList = BehaviorSubject<[PlaceModel]>(value: [PlaceModel]())
    
    
    init() {
        projectsList = projectRepo.projectList
        getProjects()
    }
    
    
    func getProjects() {
        projectRepo.getProjects()
        projectRepo.getUserInfo()
    }
    
    
}
