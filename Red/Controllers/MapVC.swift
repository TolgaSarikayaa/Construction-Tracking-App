//
//  MapVC.swift
//  Red
//
//  Created by Tolga Sarikaya on 16.08.23.
//

import UIKit
import MapKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth


class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

   
    @IBOutlet var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
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
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

    
    
    @objc func saveButton() {
        
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
                            
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser?.email!, "postComment" : PlaceModel.sharedinstance.structureName, "structureType" : PlaceModel.sharedinstance.structureType, "date" : FieldValue.serverTimestamp(), "placelatitude" : PlaceModel.sharedinstance.placeLatitude, "placeLongitude" : PlaceModel.sharedinstance.placeLongitude] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                               
                                } else {
                                    
                                    PlaceModel.sharedinstance.placeImage = UIImage(named: "AddPlaceImage")!
                                    PlaceModel.sharedinstance.structureName = ""
                                    PlaceModel.sharedinstance.structureType = ""
                                   
                                    self.performSegue(withIdentifier: "toFeed", sender: nil)
                                    
                                    
                                    
                                    
                                    
                                }
                            })
                        }
                    }
                }
            }
        }
        
    }
    
    @objc func backButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedinstance.structureType
            
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
 

}
