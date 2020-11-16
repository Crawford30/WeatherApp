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

//protocol AddWeatherDelegate {
//
//    func addWeather(weather: WeatherLocation)
//
//}

class MapViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var weatherObject = WeatherLocation.init(name: "", latitude: 0.0, longitude: 0.0)
    
    @IBOutlet weak var mapVC: MKMapView!
    @IBOutlet weak var placeMarkerImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    
    var cityName: String = ""
    var countryName: String = ""
    
    
    //    var lat: Double = 0.0
    //    var long: Double = 0.0
    //    var streetName = ""
    
    var newLocationArray: [WeatherLocation] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
       
       self.setMapview()
        
        
    }
    
    
    
   
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    func setMapview(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapVC.addGestureRecognizer(lpgr)
    }
    
    
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureReconizer.location(in: mapVC)
            let locationCoordinate = mapVC.convert(touchLocation,toCoordinateFrom: mapVC)
            
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            
            
            
              let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            
            
           // print("THIS IS LOCATION: \(location)")
            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                
                else if let placemarks = placemarks {
                    
                    for placemark in placemarks {
                        
                        self.countryName  =  placemark.country!
                        let name  =  placemark.name
                        let subThourough =   placemark.subThoroughfare
                        let thoroughfare =  placemark.thoroughfare
                        let locality = placemark.locality
//                        placemark.subAdministrativeArea
                        
                        
                        
                         print("THIS IS THE NAME: \(name)")
                        
                         print("THIS IS THE subThourough: \(subThourough)")
                         print("THIS IS THE LOCALITY: \(locality)")
                        
                        
                        DispatchQueue.main.async {
                            
                            self.addressLabel.text! =  name!
                            
                        }
                    }
                    
                    self.weatherObject = WeatherLocation.init(name: self.countryName, latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
                    
                    self.saveNewLocationObject()
                    
                    
                    
                   
                    
                    
                    
                }
                
                
                
                
                
            }
            
            
            
            
          

            
            
           
            
            
//            geoCoder.reverseGeocodeLocation(location) {  placemarks, error -> Void in
//
//
//
//                print("THIS IS LOCATION LAT: \(locationCoordinate)")
//
//
//
//
//
//                  print("THIS IS LONGITUDE LAT: \(longitudeCordinate)")
//
//                // Place details
//                guard let placeMark = placemarks?.first else { return }
//
//
//
//                //City
//                if let city = placeMark.subAdministrativeArea {
//                    print("THIS IS THE CITY: \(city)")
//
//                    self.cityName = city
//
//                }
                
                
                
                
//                // Country
//                if let country = placeMark.country {
//                    print("THIS IS THE COUNTRY: \(country)")
//
//                    self.countryName = country
//                }
//
//                self.weatherObject = WeatherLocation.init(name: self.countryName, latitude: latitudeCordinate, longitude: longitudeCordinate)
//
//
//                self.saveNewLocationObject()
//
//
//                DispatchQueue.main.async {
//                    self.addressLabel.text = "\(self.countryName),  \(self.cityName)"
//
//
//
//                }
                
                
//            }
//
            
            
            
            
            
            return
        }
        if gestureReconizer.state != UIGestureRecognizer.State.began {
            return
        }
    }
    
    
    
    
    
    
    func saveNewLocationObject() {
        
        do {
            
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: weatherObject, requiringSecureCoding: false)
            
            print("NEW LOCATION OBJECT: \(weatherObject)")
            
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


//extension MapViewController: MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        let center = getCenterLocation(for: mapView)
//        let geoCoder = CLGeocoder()
//
//        guard let previousLocation = self.previousLocation else { return }
//
//        guard center.distance(from: previousLocation) > 50 else { return }
//        self.previousLocation = center
//
//        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
//            guard let self = self else { return }
//
//            if let _ = error {
//                //TODO: Show alert informing the user
//                return
//            }
//
//            guard let placemark = placemarks?.first else {
//                //TODO: Show alert informing the user
//                return
//            }
//
//
//
////            var tempID: WeatherLocation //the class
////            //  self.newLocationArray = [] // Temporarily clear Array
////            tempID = WeatherLocation.init(name: "", latitude: 0.0, longitude: 0.0)
////
////
////
////            let lat = placemark.location?.coordinate.latitude ?? 0
////            let long = placemark.location?.coordinate.longitude ?? 0
////
////            let streetNumber = placemark.subThoroughfare ?? ""
////            let streetName = placemark.thoroughfare ?? "Unkown Place"
////
//
//
//            //====save the location on that place marker clicked
//
//            //======  Save Results to singleton  when a user click on the image pin and retive them  the Location list vc ========
//
//            // print("STREET NAME: \(streetName)")
//            //            DispatchQueue.main.async {
//            //                self.addressLabel.text = "\(streetNumber) \(streetName)"
//            //
//            //
//            //                //            print("THIS IS ARRAY OBJECT BEING SAVE: \(tempID)")
//            //
//            //                tempID.name = streetName
//            //                tempID.longitude = long
//            //                tempID.latitude = lat
//            //
//            //                self.newLocationArray.append(tempID)
//            //
//            //
//            //
//            //
//            //            }
//            //
//
//
//
//
//
//
//
//
//
//        }
//    }
//}
