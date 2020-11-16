//
//  DailyTableViewCell.swift
//  WeatherApp
//
//  Created by JOEL CRAWFORD on 11/16/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    @IBOutlet weak var dailyImageView: UIImageView!
    
    @IBOutlet weak var dailyWeekDayLabel: UILabel!
    
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var dailyRainchancesLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var windInfoLabel: UILabel!
    
    
    //===property onserver to hold the daily weather data
    
    var dailyWeather: DailyWeatherStruct! {
        didSet {
            dailyImageView.image = UIImage(named: dailyWeather.dailyIcon)
            dailyWeekDayLabel.text = dailyWeather.dailyWeekday
            
            highTempLabel.text = "\(dailyWeather.dailyHigh)°"
            lowTempLabel.text = "\(dailyWeather.dailyLow)°"
            dailyRainchancesLabel.text = "\(Int(dailyWeather.dailyDewpoint.rounded()))"
            
            humidityLabel.text = "\(Int(dailyWeather.dailyHumidity.rounded())) %"
            
            windInfoLabel.text =  "\(Int(dailyWeather.dailyWindSpeed.rounded())) "
            
            
            
        }
        
    }
    
}
