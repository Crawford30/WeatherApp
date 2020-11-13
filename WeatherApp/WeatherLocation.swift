//
//  WeatherLocation.swift
//  WeatherApp
//
//  Created by JOEL CRAWFORD on 11/13/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import Foundation


class WeatherLocation: Codable{
    
    var name: String
    var latitude: Double
    var longitude: Double
    
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
    
    //======func to get data
    
    func getData() {
        
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=33.441792&lon=-94.037689&appid=10f09520ecd91670d285f15548b94940"
        
        //create a url from string
        guard let url =  URL(string: urlString) else {
            print("Error: Could not create a URL!")
            return
        }
        
        //url session
        let session = URLSession.shared
        
        
        //Get data with datatask
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                
                print("Error: \(error.localizedDescription)")
                
            }
            
            //Deal with the data, turn the data into json
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                print("THIS IS JSON: \(json)")
                
                
            } catch {
                
                print("JSON ERROR: \(error.localizedDescription)")
                
            }
            
        }
        
        task.resume()
        
        
    }
    
 
}


