//
//  LocationDetailViewViewController.swift
//  WeatherApp
//
//  Created by JOEL CRAWFORD on 11/13/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d, h:mm aaa" //date format
    return dateFormatter
    
}()


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
    var imageName: String = ""
    
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
        
        placeLabel.text = locationNameValue
        
        getLocationDetailData()
        
        
    }
    
    
    
    
    
    
    //==============FUNC load Detail of weather =======
    
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
            
            
            //=====dealing with data.============
            
            do {
                
                //                let json = try JSONSerialization.jsonObject(with: data!, options:[])
                
                let result = try JSONDecoder().decode(Result.self, from: data!)
                
                print("THIS IS MY JSON: \(result)")
                
                
                let temperature = String(Int(result.current.temp.rounded()))
                
                //time zone
                print("Result timezone: \(result.timezone)")
                
                DispatchQueue.main.async {
                    
                    dateFormatter.timeZone = TimeZone(identifier: result.timezone)
                    let userbleDate = Date(timeIntervalSince1970: TimeInterval(result.current.dt))
                    
                    
                    self.imageName = self.fileNameForIcon(icon: result.current.weather[0].icon)
                    
                    
                    self.dateLabel.text = dateFormatter.string(from: userbleDate)
                    self.tempLabel.text = "\(temperature)°"
                    self.summaryLabel.text = result.current.weather[0].description
                    self.imageView.image   = UIImage(named:self.imageName )
                }
                
                
                
                
            } catch {
                
                print("JSON ERROR: \(error.localizedDescription)")
                
            }
            
            
            
        }
        
        task.resume()
        
        
        
    }
    
    
    //======= GETTING ICON FROM NAME====
    private func fileNameForIcon(icon: String) -> String {
        
        var newFileName = ""
        switch icon {
            
        case "0ld":
            newFileName = "clear-day"
            
        case "01n":
            newFileName = "clear-night"
            
        case "02d":
            newFileName = "partly-cloudy-day"
            
        case "02n":
            newFileName = "partly-cloudy-night"
            
        case "03d", "03n", "04d", "04n":
            newFileName = "cloudy"
            
        case "09d", "09n", "10d", "10n":
            newFileName = "rain"
            
        case "11d", "11n":
            newFileName = "thunderstorm"
            
        case "13d", "13n":
            newFileName = "snow"
            
        case "50d", "50n":
            newFileName = "fog"
        default:
            newFileName = ""
        }
        
        return newFileName
    }
    
    
    
    
}




