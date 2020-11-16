//
//  LocationDetailViewViewController.swift
//  WeatherApp
//
//  Created by JOEL CRAWFORD on 11/13/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit


struct Result:Codable {
    var timezone: String
    var current: Current
    
    
}
struct Current: Codable {
    var dt: TimeInterval
    var temp: Double
    var weather: [Weather]
}

struct Weather: Codable {
    var description: String
    var icon: String
    
    
}



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
    var timeZone: String = ""
    
    
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
    
    //https://api.openweathermap.org/data/2.5/onecall?lat=33.441792&lon=-94.037689&exclude=hourly,daily&appid={API key}
    
    //https://api.openweathermap.org/data/2.5/onecall?lat=28.79779768641177&lon=33.90499578898962&appid=10f09520ecd91670d285f15548b94940
    
    
    func updateUserInterface(){
        dateLabel.text = ""
        placeLabel.text = weatherLocation.name
        //https://youtu.be/Ga0zEDXRYhg?list=PL9VJ9OpT-IPQx1l2RjVx_n4RqzWyvdlME&t=747
//        tempLabel.text = "--°"
        summaryLabel.text = ""
        
    }
    
    
    func getStoredValuesFromCellTapped() {
        
        latituteValue = shared.getLatValue()
        print("THIS IS LAT value: \(latituteValue)")
        
        longitudeValue = shared.getLongValue()
        print("THIS IS LONG value: \(longitudeValue)")
        
        locationNameValue = shared.getLocationName()
        print("THIS IS LOCATION NAME: \(locationNameValue)")
        
        
        
        getLocationDetailData()
        
        
    }
    
    
    
    
    
    
    //==============FUNC load Detail of weather =======
    ///Getting the latitude and langitude value from the table view on didselect tap======completed: @escaping () -> () t for execution to return result before it continues
    
    func getLocationDetailData() {
        
        let apiKey = APIKey.openWeatherKey
        
        let urlString =  "https://api.openweathermap.org/data/2.5/onecall?lat=\(latituteValue)&lon=\(longitudeValue)&exclude=minutely&units=imperial&appid=\(apiKey)"
        
        
        print("THIS IS URL STRING IN DEATIL VC: \(urlString)")
        
        //creat url from string
        guard let url = URL(string: urlString) else {
            print("Could not create the url from:  \(urlString) String")
            
         
            
           return
            
        }
        
        //create session
        let session = URLSession.shared
        
        //Get the data task
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            
            //dealing with data.
            
            do {
                
//                let json = try JSONSerialization.jsonObject(with: data!, options:[])
                
                let result = try JSONDecoder().decode(Result.self, from: data!)
                
                print("THIS IS MY JSON: \(result)")
                
                
                let temperature = String(Int(result.current.temp.rounded()))
                print("Result timezone: \(result.timezone)")
                
                DispatchQueue.main.async {
                   self.dateLabel.text = result.timezone
                    self.tempLabel.text = "\(temperature)°"
                    self.summaryLabel.text = result.current.weather[0].description
//                    self.imageView   = result.current.weather[0].icon
                }
               
                
                
                
            } catch {
                
                print("JSON ERROR: \(error.localizedDescription)")
                
            }
            
             
            
        }
        
        task.resume()
        
        
        
    }
    
    
 
    
    
}




