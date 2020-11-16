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



class MapViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var weatherObject = WeatherLocation.init(name: "", latitude: 0.0, longitude: 0.0)
    
    @IBOutlet weak var mapVC: MKMapView!
    @IBOutlet weak var placeMarkerImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    var cityName: String = ""
    var countryName: String = ""
    var locality: String = ""
    
    
    
    var newLocationArray: [WeatherLocation] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.setMapview()
        
        
    }
    
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //==================================HANDLE TAPS ON A MAP TO PICK LOCATION ==================
    func setMapview(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapVC.addGestureRecognizer(lpgr)
    }
    
    
    
    
    //================================================
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureReconizer.location(in: mapVC)
            let locationCoordinate = mapVC.convert(touchLocation,toCoordinateFrom: mapVC)
            
            
            
            
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            
            
            
            
            //Location ===============
            let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            
            
            // print("THIS IS LOCATION: \(location)")
            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                    
                else if let placemarks = placemarks {
                    
                    for placemark in placemarks {
                        
                        self.countryName  =  placemark.country ?? "No Location"
                        let name  =  placemark.name
                        let subThourough =   placemark.subThoroughfare
                        let thoroughfare =  placemark.thoroughfare
                        self.locality = placemark.locality ?? ""
                        //                        placemark.subAdministrativeArea
                        
                        
                        
                        print("THIS IS THE NAME: \(name)")
                        
                        print("THIS IS THE subThourough: \(subThourough)")
                        print("THIS IS THE LOCALITY: \(self.locality)")
                        
                        
                        DispatchQueue.main.async {
                            
                            self.addressLabel.text! =  name!
                            
                        }
                    }
                    
                    
                    //PUT THE DATA IN AN OBJECT
                    
                    
                    
                    self.weatherObject = WeatherLocation.init(name: self.locality, latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
                    
                      self.saveNewLocationObject()
                    
                }
                
                
            }
            
            
            
            
            
            
            
            
            
            
            
            //            geoCoder.reverseGeocodeLocation(location) {  placemarks, error -> Void in
            //
            //
            //
            //                print("THIS IS LOCATION LAT: \(locationCoordinate)")
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
    
    
    
    
    
    //==============================================================================
    func saveNewLocationObject() {
        
        do {
            
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: weatherObject, requiringSecureCoding: false)
            
            print("NEW LOCATION OBJECT: \(weatherObject)")
            
            UserDefaults.standard.set( encodedData, forKey: "weather" )
            
        } catch {
            
            print("Problem saving data")
            
        }
        
        
    }
    
    

}


