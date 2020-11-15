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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        // Do any additional setup after loading the view.
    }
    
    func setUpLocationManager() {
        locaionManager.delegate = self
        
        locaionManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        
    }
    
    
    
    
    
    func checkLocationService() {
        
        if CLLocationManager.locationServicesEnabled(){
            
            //set location manager
            
            setUpLocationManager()
            
            
        } else {
            //alert to show location
        }
        
    }
    

   
}

extension MapViewController: CLLocationManagerDelegate {
    
    
    //updating loaction
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
}
