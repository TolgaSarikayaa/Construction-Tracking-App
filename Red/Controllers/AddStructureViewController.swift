//
//  AddStructureViewController.swift
//  Red
//
//  Created by Tolga Sarikaya on 28.06.23.
//

import UIKit
import JGProgressHUD

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
        
        let actionSheet = UIAlertController(title: "Structure", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Chose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
        
    }
        
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

}
