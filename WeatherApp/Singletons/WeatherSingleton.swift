//
//  WeatherSingleton.swift
//  WeatherApp
//
//  Created by JOEL CRAWFORD on 11/15/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit


class WeatherSingleton {
    
    static let shared = WeatherSingleton()
    
    private var latitudeValue: Double
    private var longitudeValue: Double
    private var locationName: String
    
    
    private init() {
        
        latitudeValue = 0.0
        longitudeValue = 0.0
        locationName = ""
    }
    
    
    
    func setLatValue(theValue: Double) -> () {
        
        latitudeValue = theValue
        
    }
    
    
    func setLongValue(theValue: Double) -> () {
        
        longitudeValue = theValue
        
    }
    
    
    
    func setLocationName(theName: String) -> () {
        
        locationName         =    theName
        
    }
    
    
    
    
    //GETTING DATA======GETTERS============
    
    func getLatValue() -> Double {
        
        return latitudeValue
    }
    
    func getLongValue() -> Double {
        
        return longitudeValue
    }
    
    func getLocationName() -> String {
        
        return locationName
    }
    
    
    
    
    
}

