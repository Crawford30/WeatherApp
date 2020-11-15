//
//  MapView.swift
//  WeatherApp
//
//  Created by JOEL CRAWFORD on 11/14/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UIBarButtonItem!
    
    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func searchBarAction(_ sender: UIBarButtonItem) {
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
        
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //ignoring user events
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //activity indicator
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        //hide sarch bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        
        //creating search request
        let  localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        
        //start search
        let activeSearch = MKLocalSearch(request: localSearchRequest)
        
        activeSearch.start { (response, error) in
            
            //remove activity indicator
            activityIndicator.stopAnimating()
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                
                
                self.displayMessage(userMessage: "Error has occured. Please try again!")
                
               
                
            } else {
                //Remove annotation each time you get a locatiin
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                
                //Get the data
                let latitude  = response?.boundingRegion.center.latitude
                
                let longitude  = response?.boundingRegion.center.longitude
                
                //create annotatavtion based on data
                
                let annot = MKPointAnnotation()
                annot.title = searchBar.text
                annot.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                
                self.myMapView.addAnnotation(annot)
                
                //zooming in on annotation
                
                let cord:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                
                let span = MKCoordinateSpan(latitudeDelta: latitude!, longitudeDelta: longitude!)
                
                let region = MKCoordinateRegion(center: cord, span: span)
                
                self.myMapView.setRegion(region, animated: true)
                
              
            }
            
        }
        
        

        
        
        
        
        
        
    }
    
    
    
    @IBAction func backPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
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
    
    
    
    
    
}





