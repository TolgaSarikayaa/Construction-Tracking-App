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
        
        
        welcomeLabel.font = UIFont(name: "CroissantOne-Regular", size: 45)
        projectLabel.font = UIFont(name: "CroissantOne-Regular", size: 28)
     
        
        
        
        
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
 

}
