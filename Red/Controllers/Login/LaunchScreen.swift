//
//  LaunchScreen.swift
//  Red
//
//  Created by Tolga Sarikaya on 02.09.23.
//

import UIKit

class LaunchScreen: UIViewController {

  
    @IBOutlet var startButton: UIButton!
    
    @IBOutlet var welcomeLabel: UITextField!
    
    @IBOutlet var projectLabel: UILabel!
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.layer.cornerRadius = 15
        startButton.layer.masksToBounds = true
        
        welcomeLabel.font = .systemFont(ofSize: 46, weight: .heavy)
        projectLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        
        
        
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
 

}
