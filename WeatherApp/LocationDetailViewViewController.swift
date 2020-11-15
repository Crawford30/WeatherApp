//
//  LocationDetailViewViewController.swift
//  WeatherApp
//
//  Created by JOEL CRAWFORD on 11/13/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit

class LocationDetailViewViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var weatherLocation: WeatherLocation!
    var weatherLocationsArray :[WeatherLocation] = []
    
    var shared = WeatherSingleton.shared
    var latituteValue: Double = 0.0
    var longitudeValue: Double =  0.0
    var locationNameValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //check
        if weatherLocation == nil {
            weatherLocation = WeatherLocation(name: "Current Location", latitude: 0.0, longitude: 0.0)
            
            weatherLocationsArray .append(weatherLocation)
        }
        
        
        updateUserInterface()
        // Do any additional setup after loading the view.
        
        
        getStoredValuesFromCellTapped()
    }
    
    
    func updateUserInterface(){
        dateLabel.text = ""
        placeLabel.text = weatherLocation.name
        //https://youtu.be/Ga0zEDXRYhg?list=PL9VJ9OpT-IPQx1l2RjVx_n4RqzWyvdlME&t=747
        tempLabel.text = "--°"
        summaryLabel.text = ""
        
    }
    
    
    func getStoredValuesFromCellTapped() {
        
        latituteValue = shared.getLatValue()
        print("THIS IS LAT value: \(latituteValue)")
        
        longitudeValue = shared.getLongValue()
        print("THIS IS LONG value: \(longitudeValue)")
        
        locationNameValue = shared.getLocationName()
        print("THIS IS LOCATION NAME: \(locationNameValue)")
        
        
        
        
    }
    
    
    
    
    
    
    
}




