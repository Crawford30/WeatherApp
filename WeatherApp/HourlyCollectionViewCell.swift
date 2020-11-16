//
//  HourlyCollectionViewCell.swift
//  WeatherApp
//
//  Created by JOEL CRAWFORD on 11/16/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var hourlyImage: UIImageView!

    @IBOutlet weak var hourylyTemperature: UILabel!
    
    var hourlyWeatherArray: HourlyWeatherStruct! {
        
        didSet{
            
            hourLabel.text = hourlyWeatherArray.hour
            hourlyImage.image = UIImage(named: hourlyWeatherArray.hourlyIcon)
            hourylyTemperature.text = "\(hourlyWeatherArray.hourlyTemp)°"
            
            
        }
        
        
    }
    
}
