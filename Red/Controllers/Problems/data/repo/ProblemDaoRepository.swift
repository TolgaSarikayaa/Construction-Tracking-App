//
//  ProblemDaoRepository.swift
//  Red
//
//  Created by Tolga Sarikaya on 10.11.23.
//

import Foundation
import FirebaseFirestore
import RxSwift

class ProblemDaoRepository {
    var problemList = BehaviorSubject<[Problem]>(value: [Problem]())
    var collectionProblems = Firestore.firestore()
    
    
    func getProblems() {
        var list = [Problem]()
        
        collectionProblems.collection("Problems").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                _ = UIAlertController.Alert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty != true {
                    list.removeAll(keepingCapacity: false)
                   
                    if let documents = snapshot?.documents {
                        for document in documents {
                            let data = document.data()
                            
                            let id = document.documentID
                            let person = data["person"] as? String ?? ""
                            let imageUrl = data["image"] as? String ?? ""
                            let mistake = data["mistake"] as? String ?? ""
                            
                            let problem = Problem(projectEngineer: person, problemImage: imageUrl, problemExplain: mistake, documentId: id)
                            list.append(problem)
                        }
                        
                    }
                    
                    self.problemList.onNext(list)
                }
            }
            
           
            
        }
    }
    
    
}
