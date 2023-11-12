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
            
            if let latitude = Double(p.placeLatitude!), let longitude = Double(p.placeLongitude!) {
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                let region = MKCoordinateRegion(center: location, span: span)
                
                projectLocation.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = p.structureName
                projectLocation.addAnnotation(annotation)
            }
        }
    }

    // MARK: - Functions
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
        if Double((projectDetail?.placeLatitude)!) != 0.0 &&  Double((projectDetail?.placeLongitude)!) != 0.0 {
            let requestLocation = CLLocation(latitude: Double((projectDetail?.placeLatitude)!)!, longitude: Double((projectDetail?.placeLongitude)!)!)
            
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
