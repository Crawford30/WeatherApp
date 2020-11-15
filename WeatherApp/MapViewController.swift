//
//  MapViewController.swift
//  WeatherApp
//
//  Created by JOEL CRAWFORD on 11/15/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet weak var mapVC: MKMapView!
    @IBOutlet weak var placeMarkerImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    
    
//    var lat: Double = 0.0
//    var long: Double = 0.0
//    var streetName = ""
    
    var newLocationArray: [WeatherLocation] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeMarkerImageView.isUserInteractionEnabled = true
        
        checkLocationServices()
    }
    
    
    
    
    
    //=========SAVE CURRENT DATA ON PIN IMAGE TAPPED ======
    @IBAction func saveUserLocation(_ sender: UITapGestureRecognizer) {
        
        saveNewLocationObject()
        
        print("User location tapped")
        
       
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    func saveNewLocationObject() {
        
        do {
            
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: newLocationArray, requiringSecureCoding: false)
            
            print("NEW LOCATION ARRAY: \(newLocationArray)")
            
            UserDefaults.standard.set( encodedData, forKey: "weather" )
            
        } catch {
            
            print("Problem saving data")
            
        }
        
        
    }
    
    
    
    
    
    //=========================
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapVC.setRegion(region, animated: true)
        }
    }
    
    
    
    //============CHECK LOCATION SERVICE =====
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    
    //================CHECK AUTH ===========
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    
    func startTackingUserLocation() {
        mapVC.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapVC)
    }
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}


extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            
            
            var tempID: WeatherLocation //the class
          //  self.newLocationArray = [] // Temporarily clear Array
            tempID = WeatherLocation.init(name: "", latitude: 0.0, longitude: 0.0)
            
            
            
            let lat = placemark.location?.coordinate.latitude ?? 0
            let long = placemark.location?.coordinate.longitude ?? 0
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? "Unkown Place"
            
            
            
            //====save the location on that place marker clicked
           
            //======  Save Results to singleton  when a user click on the image pin and retive them  the Location list vc ========
            
            // print("STREET NAME: \(streetName)")
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName)"
                
            
//            print("THIS IS ARRAY OBJECT BEING SAVE: \(tempID)")
                
                tempID.name = streetName
                tempID.longitude = long
                tempID.latitude = lat
                
                self.newLocationArray.append(tempID)
                
                
             
                
            }
            
            
           
            
          
                          
        }
    }
}
