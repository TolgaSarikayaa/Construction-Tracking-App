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
    
    // MARK: - Properties
    var choosenPlaceId = [String]()
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    var choosenImageArray = [String]()
    var choosenImage: String = ""
    var choosenName : String = ""
    var choosenType : String = ""
    var choosenEnginer : String = ""
    var choosenBudget : String = ""
    
    var projectDetail: PlaceModel?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectLocation.delegate = self
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButton))
        
        if let p = projectDetail {
            projectNameLabel.text = p.structureName
            projectTypeLabel.text = p.structureType
            engineerLabel.text = p.engineer
            budgetLabel.text = p.budget
            projectImageView.sd_setImage(with: URL(string: p.imageUrl!), completed: nil)
            
            
        }
        
      
    
       //getDataFromPost()
        
        
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
                    self.choosenName.removeAll(keepingCapacity: false)
                    self.choosenType.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let data = document.data()
                        let projectId = document.documentID
                        
                        if let imageUrl = data["imageUrl"] as? String {
                            self.projectDetail?.imageUrl = imageUrl
                            self.projectImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
                        }
                        
                        if let postName = data["structurName"] as? String {
                            self.projectDetail?.structureName = postName
                            //self.choosenName = postName
                            self.projectNameLabel.text = postName
                        }
                        
                        if let postStructureType = data["structureType"] as? String {
                            self.projectDetail?.structureType = postStructureType
                            //self.choosenType = postStructureType
                            self.projectTypeLabel.text = postStructureType
                        }
                        
                        if let postEnginnerName = data["Engineer"] as? String {
                            self.projectDetail?.engineer = postEnginnerName
                            //self.choosenEnginer = postEnginnerName
                            self.engineerLabel.text = postEnginnerName
                        }
                
                        if let postBudget = data["Budget"] as? String {
                            self.projectDetail?.budget = postBudget
                            //self.budgetLabel.text = postBudget
                        }
                        
                        if let postLatitude = data["placelatitude"] as? String, let placelatitude = Double(postLatitude),
                                                  let postLongitude = data["placeLongitude"] as? String, let placeLongitude = Double(postLongitude) {
                            self.projectDetail?.placeLatitude = String(placelatitude)
                            self.projectDetail?.placeLongitude = String(placeLongitude)
                                                   //self.choosenLatitude = placelatitude
                                                   //self.choosenLongitude = placeLongitude

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

}
