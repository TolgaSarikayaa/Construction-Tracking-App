//
//  AddStructureViewController.swift
//  Red
//
//  Created by Tolga Sarikaya on 28.06.23.
//

import UIKit

class AddStructureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   
    @IBOutlet var structureName: UITextField!
    
    @IBOutlet var structureType: UITextField!
    
    
    @IBOutlet var placeImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Structure"
        view.backgroundColor = .white
        
        placeImage?.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        placeImage?.addGestureRecognizer(gestureRecognizer)
       
    }
    

    
    @IBAction func nextButtonClicked(_ sender: Any) {
     
        
    }
    
    @objc func chooseImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    
    

}
