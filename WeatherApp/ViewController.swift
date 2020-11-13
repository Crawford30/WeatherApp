//
//  ViewController.swift
//  WeatherApp
//
//  Created by JOEL CRAWFORD on 11/13/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tabelView: UITableView!
    
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var weatherLocationsArray: [WeatherLocation] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegates
        tabelView.delegate = self
        tabelView.dataSource  = self
        
        var weatherLocation = WeatherLocation(name: "A", latitude: 0, longitude: 0)
        weatherLocationsArray.append(weatherLocation)
        
        weatherLocation = WeatherLocation(name: "B", latitude: 0, longitude: 0)
        weatherLocationsArray.append(weatherLocation)
        
        weatherLocation = WeatherLocation(name: "C", latitude: 0, longitude: 0)
        weatherLocationsArray.append(weatherLocation)
        
        
        
    }
    
    //======Bar Button Actions
    
    @IBAction func editBarBtnPressed(_ sender: UIBarButtonItem) {
        
        if tabelView.isEditing {
            tabelView.setEditing(false, animated: true)
            sender.title? = "Edit"
            
            addBarButton.isEnabled = false
        }else {
            
            tabelView.setEditing(true, animated: true)
            sender.title? = "Done"
            
            addBarButton.isEnabled = false
            
        }
    }
    
    @IBAction func addBarBtnPressed(_ sender: UIBarButtonItem) {
    }
}




//=====Tabel view Extension =====

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        weatherLocationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let cell = tabelView.dequeueReusableCell(withIdentifier: "TabelCell", for: indexPath)
        
        let weatherLocationObject = weatherLocationsArray[indexPath.row]
        
        cell.textLabel?.text = weatherLocationObject.name
        
        return cell
    }
    
    
}
