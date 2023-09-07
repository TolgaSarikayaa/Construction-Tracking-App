//
//  DetailTableViewController.swift
//  Red
//
//  Created by Tolga Sarikaya on 06.09.23.
//

import UIKit
import MapKit
import FirebaseFirestore
import SDWebImage

class DetailTableViewController: UITableViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    // MARK: - UI Elements
    @IBOutlet var projectNameLabel: UILabel!
    
    @IBOutlet var projectTypeLabel: UILabel!
    
    @IBOutlet var engineerLabel: UILabel!
    
    @IBOutlet var budgetLabel: UILabel!
    
    @IBOutlet var projectImageView: UIImageView!
    
    @IBOutlet var projectLocation: MKMapView!
    
    var choosenPlaceId = [String]()
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    var choosenImageArray = [String]()
    
    var choosenImage: String = ""
    var choosenName: String = ""
    var choosenType: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectLocation.delegate = self
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButton))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addButton))
        
        getDataFromPost()

    }

    // MARK: - Functions
    
    func getDataFromPost() {
        
        let firestoreData = Firestore.firestore()
        
        firestoreData.collection("Post").addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true {
                    
                    self.choosenPlaceId.removeAll(keepingCapacity: false)
                    
                 
                    
                    
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        self.choosenPlaceId.append(documentId)
                        
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.projectImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
                        }
                        
                        if let postName = document.get("postComment") as? String {
                            self.projectNameLabel.text = postName
                        }
                        
                        if let postStructureType = document.get("structureType") as? String {
                            self.projectTypeLabel.text = postStructureType
                        }
                        
                        if let postEnginnerName = document.get("Engineer") as? String {
                            self.engineerLabel.text = postEnginnerName
                        }
                        
                        if let postBudget = document.get("Budget") as? String {
                            self.budgetLabel.text = postBudget
                        }
                        
                        if let postLatitude = document.get("placelatitude") as? String, let placelatitude = Double(postLatitude),
                           let postLongitude = document.get("placeLongitude") as? String, let placeLongitude = Double(postLongitude) {
                            self.choosenLatitude = placelatitude
                            self.choosenLongitude = placeLongitude
                            
                            let location = CLLocationCoordinate2D(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
                            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                            let region = MKCoordinateRegion(center: location, span: span)
                            self.projectLocation.setRegion(region, animated: true)
                            
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = location
                            annotation.title = self.projectNameLabel.text
                            self.projectLocation.addAnnotation(annotation)
                            
                        }
                            
                        
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button  = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.choosenLatitude != 0.0 && self.choosenLongitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.projectNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
           
        }
    }
    
    @objc func backButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addButton() {
        performSegue(withIdentifier: "toProblem", sender: nil)
    }


}
