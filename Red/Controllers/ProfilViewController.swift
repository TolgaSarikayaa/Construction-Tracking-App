//
//  ProfilViewController.swift
//  Red
//
//  Created by Tolga Sarikaya on 16.08.23.
//

import UIKit
import FirebaseAuth

class ProfilViewController: UIViewController {

    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

      title = "Profil"
   
    }
    

   
    
    // MARK: - Actions
    @IBAction func logOut(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLoginVC", sender: nil)
        } catch {
            print("Error")
        }
        
    }
    

}
