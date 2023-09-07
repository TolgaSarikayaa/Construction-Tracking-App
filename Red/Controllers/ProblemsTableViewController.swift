//
//  ProblemsTableViewController.swift
//  Red
//
//  Created by Tolga Sarikaya on 07.09.23.
//

import UIKit
import SDWebImage
import FirebaseFirestore
import FirebaseStorage

class ProblemsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - UI Elements
    @IBOutlet var mistakeText: UITextField!
    
    @IBOutlet var personText: UITextField!
    
    
    @IBOutlet var mistakeImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mistakeImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseProjectImage))
        mistakeImageView.addGestureRecognizer(gestureRecognizer)

        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButton))
       
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButton))
        
    }
    
    @objc func saveButton() {
        
        
        
    }
    
    
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
        mistakeImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    

  

    @objc func backButton() {
        self.dismiss(animated: true, completion: nil)
    }

}
