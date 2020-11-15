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
    
    let locaionManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationService()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func setUpLocationManager() {
        locaionManager.delegate = self
        
        locaionManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        
    }
    
    
    
    
    func centerViewOnUerLocation() {
        
        if let location =  locaionManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            
            mapVC.setRegion(region, animated: true)
            
        }
        
    }
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷Check what permsiison a user selected🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //Get location
            
            //show user location
            mapVC.showsUserLocation = true
            
            centerViewOnUerLocation()
            
            locaionManager.startUpdatingLocation()
            
            
            
            break
            
        case .notDetermined:
            
            //show alert instructing them how to ask for permission
            locaionManager.requestWhenInUseAuthorization()
            break
            
        case .restricted:
            
            //show them an laert
            break
            
        case .authorizedAlways:
            break
            
        default:
            break
        }
        
    }
    
    
    
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    func checkLocationService() {
        
        if CLLocationManager.locationServicesEnabled(){
            
            //set location manager
            
            setUpLocationManager()
            
            checkLocationAuthorization()
            
            
        } else {
            //alert to show location
        }
        
    }
    
    
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    
    //updating loaction
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //using last loction
        guard let location = locations.last else {
            return
        }
        
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapVC.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkLocationAuthorization()
        
    }
    
}
