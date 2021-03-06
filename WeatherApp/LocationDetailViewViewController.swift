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
    dateFormatter.dateFormat = "EEEE, MMM d" //date format
    return dateFormatter
    
}()


private let hourFormatter: DateFormatter = {
    let hourFormatter = DateFormatter()
    hourFormatter.dateFormat = "ha"
    return hourFormatter
    
}()

private let dateFormatterWeekDay: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE" //date format
    return dateFormatter
    
}()


struct Result:Codable {
    var timezone: String
    var current: Current
    var daily: [Daily]
    var hourly: [Hourly]
    
    
}
struct Current: Codable {
    var dt: TimeInterval
    var temp: Double
    var weather: [Weather]
}

struct Weather: Codable {
    var description: String
    var icon: String
    var id: Int
    
    
}


struct Daily:Codable {
    var dt: TimeInterval
    var temp: Temp
    var weather: [Weather]
    var pressure: Double
    var humidity: Double
    var dew_point: Double
    var wind_speed: Double
}


struct Hourly:Codable {
    var dt: TimeInterval
    var temp: Double
    var weather: [Weather]
}
struct Temp: Codable {
    var max: Double
    var min: Double
}



class LocationDetailViewViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    
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
    
    var dailyWeatherData: [DailyWeatherStruct] = []
    var hourlyWeatherData : [HourlyWeatherStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        horizontalCollectionView.delegate = self
        horizontalCollectionView.dataSource = self
        
        clearUserInterface()
        
        //check
        if weatherLocation == nil {
            weatherLocation = WeatherLocation(name: "Current Location", latitude: 0.0, longitude: 0.0)
            
            weatherLocationsArray .append(weatherLocation)
        }
        
        
        updateUserInterface()
        // Do any additional setup after loading the view.
        
        
        getStoredValuesFromCellTapped()
    }
    
    
    @IBAction func onListBtnTapped(_ sender: UIBarButtonItem) {
        
        //ListVC
        
        let vc = self.storyboard?.instantiateViewController(identifier: "ListVC") as! LocationListViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
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
    
    
    
    //To clear place holders entered during dsign
    func clearUserInterface() {
        
        dateLabel.text = ""
        placeLabel.text = ""
        tempLabel.text = ""
        summaryLabel.text = ""
        imageView.image = UIImage()
        
    }
    
    
    
    
    
    
    //==============FUNC load Detail of weather =======
    
    func getLocationDetailData() {
        
        let apiKey = APIKey.openWeatherKey
        
        let urlString =  "https://api.openweathermap.org/data/2.5/onecall?lat=\(latituteValue)&lon=\(longitudeValue)&exclude=minutely&units=imperial&appid=\(apiKey)"
        
        
        // print("THIS IS URL STRING IN DEATIL VC: \(urlString)")
        
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
                    
                    
                    //print("***DAILY WEATHER ARRAY*** \(result.daily)")
                    
                    for index in 0..<result.daily.count{
                        
                        let weeKDayDate = Date(timeIntervalSince1970: result.daily[index].dt)
                        
                        dateFormatterWeekDay.timeZone = TimeZone(identifier: result.timezone)
                        
                        let dailyWeekDay = dateFormatterWeekDay.string(from: weeKDayDate)
                        
                        
                        let dailyIcon = self.fileNameForIcon(icon: result.daily[index].weather[0].icon)
                        
                        let dailySummary = result.daily[index].weather[0].description
                        
                        let dailyHigh = Int(result.daily[index].temp.max.rounded())
                        
                        let dailyLow = Int(result.daily[index].temp.min.rounded())
                        
                        let dailyHumidity = result.daily[index].humidity
                        
                        let dailyPressure = result.daily[index].pressure
                        
                        let dailyWindSpeed = result.daily[index].wind_speed
                        
                        let dailyRainChance = result.daily[index].dew_point
                        
                        let dailyWeather = DailyWeatherStruct(dailyIcon: dailyIcon, dailyWeekday: dailyWeekDay, dailySummary: dailySummary, dailyHigh: dailyHigh, dailyLow: dailyLow, dailyHumidity: dailyHumidity, dailyPressure: dailyPressure, dailyDewpoint: dailyWindSpeed, dailyWindSpeed: dailyRainChance)
                        
                        
                        
                        self.dailyWeatherData.append(dailyWeather)
                        
                        //print("Day: \(dailyWeekDay), Low: \(dailyLow), High: \(dailyHigh), Pressure: \(dailyPressure),  Humidity: \(dailyHumidity)")
                        
                        self.tableView.reloadData()
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    //======HOURLY DATA ===============
                    
                    //=====get not more than 24 hours data=======
                    
                    let lastHour = min(24, result.hourly.count)
                    
                    if lastHour > 0 {
                        
                        for index in 1...lastHour{ //close range
                            
                            let hourlyDate = Date(timeIntervalSince1970: result.hourly[index].dt)
                            
                            hourFormatter.timeZone = TimeZone(identifier: result.timezone)
                            
                            let hour = hourFormatter.string(from: hourlyDate)
                            
                            
                            //let hourlyIcon = self.fileNameForIcon(icon: result.hourly[index].weather[0].icon)
                            
                            let hourlyIcon = systemNameFromID(id: result.hourly[index].weather[0].id, icon: result.hourly[index].weather[0].icon)
                            
                            let hourlyTemp = Int(result.hourly[index].temp.rounded())
                            
                            let hourlyWeather = HourlyWeatherStruct(hour: hour, hourlyTemp: hourlyTemp, hourlyIcon: hourlyIcon)
                            
                            
                            self.hourlyWeatherData.append(hourlyWeather)
                            
                            //print("HOUR: \(hour), Hourly Temp: \(hourlyTemp), Hourly ICON: \(hourlyIcon)")
                            
                            self.horizontalCollectionView.reloadData()
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
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
    
    //=====Get system  image name from ID ====
    
    
    
    
    
    
    
    
    
    
    
    
}

//===========================



//GETTING WEATHER ICON FROM SF SYMBOL

func systemNameFromID(id: Int, icon: String) -> String {
    switch id {
    case 200...299:
        return "cloud.bolt.rain"
        
    case 300...399:
        return "cloud.drizzle"
        
    case 500, 501, 520, 521,531:
        return "cloud.rain"
        
    case 502, 503, 504, 522:
        return "cloud.heavyrain"
        
    case 511,611...616:
        return "sleet"
        
    case 600...602, 620...622:
        return "snow"
        
    case 701,711, 741:
        return "cloud.fog"
        
    case 721:
        return  (icon.hasSuffix("d") ? "sun.haze": "cloud.fog") //day or night
        
    case 731,751, 761,762:
        return  (icon.hasSuffix("d") ? "sun.dust": "cloud.fog")
        
    case 771:
        return "wind"
        
    case 781:
        return "tornado"
        
    case 800:
        return  (icon.hasSuffix("d") ? "sun.max": "moon")
        
    case 801,802:
        return  (icon.hasSuffix("d") ? "cloud.sun": "cloud.moon")
        
    case 803,804:
        return  "cloud"
        
    default:
        return "questionmark.diamond"
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}








extension LocationDetailViewViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dailyWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DailyTableViewCell
        
        cell.dailyWeather = dailyWeatherData[indexPath.row] //get the property observer asscocaited with daily weather
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}





extension LocationDetailViewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return hourlyWeatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let HourlyCell = horizontalCollectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyCollectionViewCell
        
        
        HourlyCell.hourlyWeatherArray = hourlyWeatherData[indexPath.item] 
        return HourlyCell
    }
    
    
    
    
}
