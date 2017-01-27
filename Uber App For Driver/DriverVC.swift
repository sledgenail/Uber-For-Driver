//
//  DriverVC.swift
//  Uber App For Driver
//
//  Created by Emmanuel Erilibe on 1/27/17.
//  Copyright © 2017 Emmanuel Erilibe. All rights reserved.
//

import UIKit
import MapKit

class DriverVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var myMap: MKMapView!
    
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    private var riderLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager()
    }

    private func initializeLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locationManager.location?.coordinate {
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            myMap.setRegion(region, animated: true)
            
            myMap.removeAnnotations(myMap.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation!
            annotation.title = "Driver's Location"
            myMap.addAnnotation(annotation)
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        if AuthProvider.Instance.logOut() {
            dismiss(animated: true, completion: nil)
        } else {
            alertTheUser(title: "Could Not Logout", message: "We could not log out at the monment, please try again later")
        }
    }
    
    @IBAction func acceptUberBtnPressed(_ sender: Any) {
    }
    
    private func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
