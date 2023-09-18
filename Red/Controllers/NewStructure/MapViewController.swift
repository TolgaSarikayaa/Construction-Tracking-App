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
            let alert = UIAlertController.Alert(title: "Error", message: "Please select your coordinate", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
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
                        _ = UIAlertController.Alert(title: "Error", message: error?.localizedDescription)
                    } else {
                        imageReference.downloadURL { (url, error) in
                            if error == nil {
                                let imageUrl = url?.absoluteString
                                
                                // Database
                                let firestoreDatabase = Firestore.firestore()
                                var firestoreReference : DocumentReference? = nil
                                
                                firestoreDatabase.collection("Post").whereField("user", isEqualTo: PlaceModel.sharedinstance.username).getDocuments { (snapshot,error ) in
                                    if error != nil {
                                        _ = UIAlertController.Alert(title: "Error", message: error?.localizedDescription ?? "Error")
                                     
                                    }
                                }
                                
                                let firestorePost = ["imageUrl" : imageUrl!, "user" : PlaceModel.sharedinstance.username , "structurName" : PlaceModel.sharedinstance.structureName, "structureType" : PlaceModel.sharedinstance.structureType, "date" : FieldValue.serverTimestamp(), "placelatitude" : PlaceModel.sharedinstance.placeLatitude, "placeLongitude" : PlaceModel.sharedinstance.placeLongitude, "Engineer": PlaceModel.sharedinstance.engineer, "Budget": PlaceModel.sharedinstance.budget] as [String : Any]
                                
                                firestoreReference = firestoreDatabase.collection("Post").addDocument(data: firestorePost, completion: { (error) in
                                    if error != nil {
                                        _ = UIAlertController.Alert(title: "Error", message: error?.localizedDescription ?? "Error")
                                    } else {
                                     
            
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
    

}
