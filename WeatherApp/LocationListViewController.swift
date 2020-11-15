//
//  LocationListViewController.swift
//  WeatherApp
//
//  Created by JOEL CRAWFORD on 11/13/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit
import MapKit

class LocationListViewController: UIViewController {
    @IBOutlet weak var tabelView: UITableView!
    
    
    
    var searchController: UISearchController!
    var shouldShowSearchResults: Bool = false
    
    
    @IBOutlet weak var searchBar: UIBarButtonItem!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var weatherLocationsArray: [WeatherLocation] = []
    
    var currentFilteredArray: [WeatherLocation] = []
    
    
    
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
        
        getSavedLocation()
        
        
        
    }
    
    
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    func getSavedLocation() {
        
        let latValue = UserDefaults.standard.double(forKey: "Latitude")
        
        let  longValue = UserDefaults.standard.double(forKey:" Longitude")
        
        let streetName = UserDefaults.standard.string(forKey: "StreetName") ?? "Unkown"
        
        
        let newLocations = WeatherLocation(name: streetName, latitude: latValue, longitude: longValue)
        
        weatherLocationsArray.append(newLocations)
        
        DispatchQueue.main.async {
            
            self.tabelView.reloadData()
        }
        
       
        
    }
    
    
    
    
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
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
    
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    @IBAction func addBarBtnPressed(_ sender: UIBarButtonItem) {
        
        let nextStoryBoard:
            UIViewController = UIStoryboard(
                name: "Main", bundle: nil
            ).instantiateViewController(withIdentifier: "MapVCID") as! MapViewController
        
        nextStoryBoard.modalPresentationStyle = .fullScreen
        
        self.present(nextStoryBoard, animated: true, completion: nil)
    }
    
    
    
    //MARK:- ==== Location Search Actiom====
    @IBAction func locationSearch(_ sender: UIBarButtonItem) {
        customSearch()
        
        
    }
    
    
    
    
    
    //============function to display alert messages==================
    func displayMessage(userMessage: String) -> Void {
        
        DispatchQueue.main.async {
            
            let alertController = UIAlertController (title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) {
                
                (action: UIAlertAction!) in
                
                //==========code in this block will trigger when ok button is tapped============
                
                DispatchQueue.main.async {
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    func customSearch() {
        
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search for locations by name..."
        searchController.searchBar.tintColor = UIColor.red
        
        //will enable didSelectRowAtIndexPath
        searchController.obscuresBackgroundDuringPresentation = false
        
        
        // Set any properties (in this case, don't hide the nav bar and don't show the emoji keyboard option)
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        
        present(searchController, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
}






//🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
//=====Tabel view Extension =====

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if shouldShowSearchResults {
            
            return currentFilteredArray.count
            
        } else {
            
            return weatherLocationsArray.count
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tabelView.dequeueReusableCell(withIdentifier: "TabelCell", for: indexPath)
        
        if (shouldShowSearchResults) {
            
            let weatherLocationObject = currentFilteredArray[indexPath.row]
            
            cell.textLabel?.text = weatherLocationObject.name
            
            cell.detailTextLabel?.text = "Lat: \(weatherLocationObject.latitude), Lon: \(weatherLocationObject.longitude)"
            
            
            
        } else {
            
            
            let weatherLocationObject = weatherLocationsArray[indexPath.row]
            
            cell.textLabel?.text = weatherLocationObject.name
            
            cell.detailTextLabel?.text = "Lat: \(weatherLocationObject.latitude), Lon: \(weatherLocationObject.longitude)"
            
        }
        
        
        
        return cell
    }
    
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 100.0
    //    }
    //
    //
    
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if(shouldShowSearchResults) {
            
            print("SELECTED INDEX \(indexPath.row)")
            print("Selected Cell Name \(currentFilteredArray[indexPath.row].name)")
            
            
            
        } else {
            
            
            print("SELECTED INDEX \(indexPath.row)")
            print("Selected Cell Name \(weatherLocationsArray[indexPath.row].name)")
            
        }
        
        
        
        let vc = self.storyboard?.instantiateViewController(identifier: "DetailVC") as! LocationDetailViewViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    //Deleting/removing a boook mark a cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            if shouldShowSearchResults {
                
                
                currentFilteredArray.remove(at: indexPath.row)
                
            } else {
                weatherLocationsArray.remove(at: indexPath.row)
                
            }
            
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        }
    }
    
    
    
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    //FOR moving a cell
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if (shouldShowSearchResults) {
            
            let itemToMove  = currentFilteredArray[sourceIndexPath.row]
            currentFilteredArray.remove(at: sourceIndexPath.row)
            currentFilteredArray.insert(itemToMove, at: destinationIndexPath.row)
            
        } else {
            
            let itemToMove  = weatherLocationsArray[sourceIndexPath.row]
            weatherLocationsArray.remove(at: sourceIndexPath.row)
            weatherLocationsArray.insert(itemToMove, at: destinationIndexPath.row)
            
        }
        
        
        
    }
    
    
    
    
    
}




//🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
extension LocationListViewController: UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        
        let searchString = searchController.searchBar.text
        
        currentFilteredArray = [] //clear the array
        
        currentFilteredArray = weatherLocationsArray.filter({ (item) -> Bool in
            let locationName: NSString = item.name  as NSString
            
            return (locationName.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        tabelView.reloadData()
        
        
        
    }
    
    
}




extension LocationListViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !shouldShowSearchResults {
            
            shouldShowSearchResults = true
            tabelView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
        
    }
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tabelView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        shouldShowSearchResults = false
        tabelView.reloadData()
    }
}








