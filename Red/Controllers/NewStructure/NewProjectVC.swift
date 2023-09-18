//
//  NewProjectVC.swift
//  Red
//
//  Created by Tolga Sarikaya on 01.09.23.
//

import UIKit

class NewProjectVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:  - UI Elements
    
    @IBOutlet var projectName: UITextField!
    
    @IBOutlet var projectType: UITextField!
    
    @IBOutlet var projectImageView: UIImageView!
    
    @IBOutlet var engineerName: UITextField!
    
    @IBOutlet var budget: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseProjectImage))
        projectImageView.addGestureRecognizer(gestureRecognizer)
        
        
        
    }
    // MARK: - Funtions
    @objc func chooseProjectImage() {
        
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
        projectImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if projectName.text != "" && projectType.text != "" && engineerName.text != "" {
            performSegue(withIdentifier: "toMap", sender: nil)
            
        } else {
            let alert = UIAlertController.Alert(title: "Error", message: "Project Name/Type/Engineer?", preferredStyle: UIAlertController.Style.alert)
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap" {
            if let choosenImage = projectImageView.image {
                let placeModel = PlaceModel.sharedinstance
                placeModel.structureName = projectName.text!
                placeModel.structureType = projectType.text!
                placeModel.budget = budget.text!
                placeModel.engineer = engineerName.text!
                placeModel.placeImage = choosenImage
            }
        }
    }
    
}

