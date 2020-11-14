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
    
    var weatherLocation:WeatherLocation!
    var weatherLocations:[WeatherLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if weatherLocation == nil {
            weatherLocation = WeatherLocation(name: "Current Location", latitude: 0.0, longitude: 0.0)
            
            weatherLocations.append(weatherLocation)
        }

        
        updateUserInterface()
        // Do any additional setup after loading the view.
    }
    

    func updateUserInterface(){
        dateLabel.text = ""
        placeLabel.text = weatherLocation.name
        //https://youtu.be/Ga0zEDXRYhg?list=PL9VJ9OpT-IPQx1l2RjVx_n4RqzWyvdlME&t=747
        
    }
}
