//
//  LocationListViewController.swift
//  WeatherApp
//
//  Created by JOEL CRAWFORD on 11/13/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController {
    @IBOutlet weak var tabelView: UITableView!
    
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var weatherLocationsArray: [WeatherLocation] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegates
        self.tabelView.delegate = self
        self.tabelView.dataSource  = self
       
        
        
        
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
            sender.title? = "UnBook Mark"
            
            //disabled bar button on editting mode
            addBarButton.isEnabled = true
            
        }else {
            
            tabelView.setEditing(true, animated: true)
            sender.title? = "Done"
            
            addBarButton.isEnabled = false
            
        }
    }
    
    @IBAction func addBarBtnPressed(_ sender: UIBarButtonItem) {
        
        //MapViewID
        
        let nextStoryBoard:
            UIViewController = UIStoryboard(
                name: "Main", bundle: nil
            ).instantiateViewController(withIdentifier: "MapViewID") as! MapView
        
        nextStoryBoard.modalPresentationStyle = .fullScreen
        
        self.present(nextStoryBoard, animated: true, completion: nil)
    }
}




//=====Tabel view Extension =====

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        weatherLocationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tabelView.dequeueReusableCell(withIdentifier: "TabelCell", for: indexPath)
        
        let weatherLocationObject = weatherLocationsArray[indexPath.row]
        
        cell.textLabel?.text = weatherLocationObject.name
        
        cell.detailTextLabel?.text = "Lat: \(weatherLocationObject.latitude), Lon: \(weatherLocationObject.longitude)"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("SELECTED INDEX \(indexPath.row)")
        print("Selected Cell Name \(weatherLocationsArray[indexPath.row].name)")
        
        let vc = self.storyboard?.instantiateViewController(identifier: "DetailVC") as! LocationDetailViewViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
        //Deleting/removing a boook mark a cell
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
            if editingStyle == .delete{
    
                weatherLocationsArray.remove(at: indexPath.row)
    
                tableView.deleteRows(at: [indexPath], with: .fade)
    
    
            }
        }
    
    
    
        //FOR moving a cell
        func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let itemToMove  = weatherLocationsArray[sourceIndexPath.row]
            weatherLocationsArray.remove(at: sourceIndexPath.row)
            weatherLocationsArray.insert(itemToMove, at: destinationIndexPath.row)
    
    
        }
    
    
    
    
    
    
    
    
    
    
}
