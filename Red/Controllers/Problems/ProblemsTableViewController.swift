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
import JGProgressHUD

class ProblemsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - UI Elements
    @IBOutlet var mistakeText: UITextField!
    
    @IBOutlet var personText: UITextField!
    
    
    @IBOutlet var mistakeImageView: UIImageView!
    
    private let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mistakeImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseProjectImage))
        mistakeImageView.addGestureRecognizer(gestureRecognizer)

        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButton))
       
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButton))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        view.addGestureRecognizer(tap)
        view.endEditing(true)
        
    }
    
    @objc func saveButton() {
        
        if mistakeText.text == "" && personText.text == "" && mistakeImageView == nil {
            let alert = UIAlertController.Alert(title: "Erro", message: "Mistake?,Person?,Image", preferredStyle: .alert )
            present(alert, animated: true)
        } else {
            spinner.show(in: view)
            
            let storage = Storage.storage()
            let storageReference = storage.reference()
            
            let mediaFolder = storageReference.child("problems")
            
            if let data = mistakeImageView.image?.jpegData(compressionQuality: 0.5) {
                 
                let uuid = UUID().uuidString
                
                let imageReference = mediaFolder.child("\(uuid).jpg")
                
                imageReference.putData(data, metadata: nil) { (metadata, error) in
                    if error != nil {
                        let alert = UIAlertController.Alert(title: "Error", message: error?.localizedDescription ?? "Error")
                        self.present(alert, animated: false)
                    } else {
                        imageReference.downloadURL { (url, error) in
                            if error == nil {
                                let imageUrl = url?.absoluteString
                                
                                // FireStore
                                let fireStore = Firestore.firestore()
                                
                                fireStore.collection("Problems").whereField("User", isEqualTo: PlaceModel.sharedinstance.username).getDocuments { (snapshot, error) in
                                    if error != nil {
                                        let alert = UIAlertController.Alert(title: "Error", message: error?.localizedDescription ?? "Error")
                                        
                                    }
                                }
                                
                                
                                let firestoreProb = ["image": imageUrl!, "User": PlaceModel.sharedinstance.username, "mistake": self.mistakeText.text!, "date": FieldValue.serverTimestamp(), "person": self.personText.text!] as [String : Any]
                                
                                fireStore.collection("Problems").addDocument(data: firestoreProb) { (error) in
                                    if error != nil {
                                        let alert = UIAlertController.Alert(title: "Error", message: error?.localizedDescription ?? "Error")
                                        
                                    } else {
                                        DispatchQueue.main.async {
                                            self.spinner.dismiss()
                                        }
                                        
                                        
                                      // self.performSegue(withIdentifier: "toProblemFeed", sender: nil)
                                        //self.tabBarController?.selectedIndex = 2
                                        self.navigationController?.dismiss(animated: true)
                                        
                                    }
                                }

                            }
                        }
                    }
                }
                
            }
            
            
        }
        
        
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
