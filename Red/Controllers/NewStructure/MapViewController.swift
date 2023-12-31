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
import UserNotifications

class MapViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    // MARK: - UI Elements
    @IBOutlet var mapView: MKMapView!
    
    // MARK: - Properties
    var locationManager = CLLocationManager()
    private let spinner = JGProgressHUD(style: .dark)
    var permissionCheck = false
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarTitleColor(.black)
       
        setLightMode()
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { granted, error in
            self.permissionCheck = granted
            
            if granted {
                print("permission was successful")
            } else {
                print("permission was failed")
            }
        }

       
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
                        print(error?.localizedDescription ?? "Error")
                    } else {
                        imageReference.downloadURL { (url, error) in
                            if error == nil {
                                let imageUrl = url?.absoluteString
                                
                                // Database
                                let firestoreDatabase = Firestore.firestore()
                                var firestoreReference : DocumentReference? = nil
                                
                                firestoreDatabase.collection("Post").whereField("user", isEqualTo: PlaceModel.sharedinstance.username!).getDocuments { (snapshot,error ) in
                                    if error != nil {
                                        print(error?.localizedDescription ?? "Error")
                                     
                                    }
                                }
                                
                                let firestorePost = ["imageUrl" : imageUrl!, "user" : PlaceModel.sharedinstance.username! , "structurName" : PlaceModel.sharedinstance.structureName!, "structureType" : PlaceModel.sharedinstance.structureType!, "date" : FieldValue.serverTimestamp(), "placelatitude" : PlaceModel.sharedinstance.placeLatitude!, "placeLongitude" : PlaceModel.sharedinstance.placeLongitude!, "Engineer": PlaceModel.sharedinstance.engineer!, "Budget": PlaceModel.sharedinstance.budget!] as [String : Any]
                                
                                firestoreReference = firestoreDatabase.collection("Post").addDocument(data: firestorePost, completion: { (error) in
                                    if error != nil {
                                        print(error?.localizedDescription ?? "Error")
                                    } else {
                                        DispatchQueue.main.async {
                                            self.spinner.dismiss()
                                        }
                                        self.notification()
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
    
    func notification() {
        if permissionCheck {
            let contents = UNMutableNotificationContent()
            contents.title = "Project"
            contents.body = "New Project Added"
            contents.badge = 1
            contents.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let notificationRequest = UNNotificationRequest(identifier: "id", content: contents, trigger: trigger)
            
            UNUserNotificationCenter.current().add(notificationRequest)
        }
    }
}

// MARK: - Extension
extension MapViewController : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner,.sound,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().setBadgeCount(0, withCompletionHandler: { (error) in
        })
    }
                                                             
   }
}
    
