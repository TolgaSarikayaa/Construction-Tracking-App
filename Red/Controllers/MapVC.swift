//
//  MapVC.swift
//  Red
//
//  Created by Tolga Sarikaya on 16.08.23.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

   
    @IBOutlet var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButton))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButton))
        
    }
    

    
    
    @objc func saveButton() {
        
    }
    
    @objc func backButton() {
        self.dismiss(animated: true, completion: nil)
    }
 

}
