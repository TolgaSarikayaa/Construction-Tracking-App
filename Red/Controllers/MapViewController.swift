//
//  MapViewController.swift
//  Red
//
//  Created by Tolga Sarikaya on 01.09.23.
//

import UIKit
import MapKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import JGProgressHUD

class MapViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    // MARK: - UI Elements
    @IBOutlet var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    private let spinner = JGProgressHUD(style: .dark)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButton))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButton))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(recognizer)
        
        
      
    }
    


    // MARK: - Functions
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedinstance.structureName
            
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedinstance.placeLatitude = String(coordinates.latitude)
            PlaceModel.sharedinstance.placeLongitude = String(coordinates.longitude)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.020, longitudeDelta: 0.020)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func saveButton() {
        if PlaceModel.sharedinstance.placeLatitude == "" && PlaceModel.sharedinstance.placeLongitude == "" {
            self.makeAlert(titleInput: "Error", messageInput: "Please select your cordinate")
        } else {
            spinner.show(in: view)
            
            let storage = Storage.storage()
            let storageReference = storage.reference()
            
            let mediaFolder = storageReference.child("media")
            
            if let data = PlaceModel.sharedinstance.placeImage.jpegData(compressionQuality: 0.5) {
                
                let uuid = UUID().uuidString
                
                let imageReference = mediaFolder.child("\(uuid).jpg")
                imageReference.putData(data, metadata: nil) { (metadata, error) in
                    
                    if error != nil {
                        self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                    } else {
                        imageReference.downloadURL { (url, error) in
                            if error == nil {
                                let imageUrl = url?.absoluteString
                                
                                // Database
                                let firestoreDatabase = Firestore.firestore()
                                var firestoreReference : DocumentReference? = nil
                                
                                firestoreDatabase.collection("Post").whereField("user", isEqualTo: PlaceModel.sharedinstance.username).getDocuments { (snapshot,error ) in
                                    if error != nil {
                                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    }
                                }
                                
                                let firestorePost = ["imageUrl" : imageUrl!, "user" : PlaceModel.sharedinstance.username , "postComment" : PlaceModel.sharedinstance.structureName, "structureType" : PlaceModel.sharedinstance.structureType, "date" : FieldValue.serverTimestamp(), "placelatitude" : PlaceModel.sharedinstance.placeLatitude, "placeLongitude" : PlaceModel.sharedinstance.placeLongitude, "Engineer": PlaceModel.sharedinstance.engineer, "Budget": PlaceModel.sharedinstance.budget] as [String : Any]
                                
                                firestoreReference = firestoreDatabase.collection("Post").addDocument(data: firestorePost, completion: { (error) in
                                    if error != nil {
                                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    } else {
                                        PlaceModel.sharedinstance.placeImage = UIImage(named: "AddPlaceImage")!
                                        PlaceModel.sharedinstance.structureName = ""
                                        PlaceModel.sharedinstance.structureType = ""
                                        
                                        DispatchQueue.main.async {
                                            self.spinner.dismiss()
                                        }
                                        
                                        self.performSegue(withIdentifier: "toMain", sender: nil)
                                    }
                                })
                                
                            }
                        }
                    }
                }
                
                
                
            }
            
        }
        
    }
    
    @objc func backButton() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    

}
