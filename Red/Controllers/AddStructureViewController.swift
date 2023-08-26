//
//  AddStructureViewController.swift
//  Red
//
//  Created by Tolga Sarikaya on 28.06.23.
//

import UIKit

class AddStructureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - UI Elements
    @IBOutlet var structureName: UITextField!
    
    @IBOutlet var structureType: UITextField!
    
    
    @IBOutlet var placeImage: UIImageView!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Structure"
      
        
        placeImage?.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        placeImage?.addGestureRecognizer(gestureRecognizer)
       
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer2)
        
        
        placeImage.layer.cornerRadius = 15
       
      
        
        
        
    }
    
    
    // MARK: - Functions
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    

    @IBAction func nextButtonClicked(_ sender: Any) {
     
        if structureName.text != "" && structureType.text != "" {
            if let choosenImage = placeImage.image {
                let placeModel = PlaceModel.sharedinstance
                placeModel.structureName = structureName.text!
                placeModel.structureType = structureType.text!
                placeModel.placeImage = choosenImage
            }
            
            performSegue(withIdentifier: "toMapVC", sender: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Structure Name/Type?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true,completion: nil)
        }
        
    }
    
    @objc func chooseImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        //picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    
    

}
