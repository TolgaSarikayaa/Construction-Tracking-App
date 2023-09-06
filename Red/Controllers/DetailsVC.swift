//
//  DetailsVC.swift
//  Red
//
//  Created by Tolga Sarikaya on 22.08.23.
//

import UIKit
import MapKit
import FirebaseFirestore
import FirebaseDatabase
import SDWebImage

class DetailsVC: UIViewController, MKMapViewDelegate {

    // MARK: - UI Elements
    @IBOutlet var detailsImageView: UIImageView!
    
    @IBOutlet var detailsNameLabel: UILabel!
    
    @IBOutlet var detailsTypeLabel: UILabel!
    
    
    @IBOutlet var detailsMapView: MKMapView!
    
    var choosenPlaceId = [String]()
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    var choosenImageArray = [String]()
    
    var choosenImage: String = ""
    var choosenName: String = ""
    var choosenType: String = ""


    var selectedStructure : PlaceModel?
    
   
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"


        
        getData()
        detailsMapView.delegate = self
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButton))
    }
    
    // MARK: - Functions
    func getData() {
        
        let FirestoreData = Firestore.firestore()
        
        FirestoreData.collection("Post").addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true {
                    
                    self.choosenImage.removeAll(keepingCapacity: false)
                    self.choosenName.removeAll(keepingCapacity: false)
                    self.choosenPlaceId.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        self.choosenPlaceId.append(documentId)
                        
                        
                        if let imageUrl = document.get("imageUrl") as? String {
                            
                                self.detailsImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
                            
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.detailsNameLabel.text = postComment
                            
                        }
                        
                        if let postStructureType = document.get("structureType") as? String {
                            self.detailsTypeLabel.text = postStructureType
                        }
                        
                        if let postLatitude = document.get("placelatitude") as? String, let placelatitude = Double(postLatitude),
                           let postLongitude = document.get("placeLongitude") as? String, let placeLongitude = Double(postLongitude) {
                            self.choosenLatitude = placelatitude
                            self.choosenLongitude = placeLongitude
                            
                            
                            let location = CLLocationCoordinate2D(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
                            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                            let region = MKCoordinateRegion(center: location, span: span)
                            self.detailsMapView.setRegion(region, animated: true)
                            
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = location
                            annotation.title = self.detailsNameLabel.text
                            self.detailsMapView.addAnnotation(annotation)
                        }
                        
                    }
                    
                    
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
                        mapItem.name = self.detailsNameLabel.text
                        
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
    
   

}
