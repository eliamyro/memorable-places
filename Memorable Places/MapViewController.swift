//
//  MapViewController.swift
//  Memorable Places
//
//  Created by Elias Myronidis on 29/4/17.
//  Copyright © 2017 eliamyro. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet weak var map: MKMapView!
    
    var locationsBundle:[Any]?
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var storedPlaces = [Dictionary<String, String>()]
    var activePlace: Int?
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let locBundle = locationsBundle{
            activePlace = locBundle[1] as? Int
            storedPlaces = (locBundle[0] as? [Dictionary<String, String>])!
            
            if let nameTemp = storedPlaces[activePlace!]["name"]{
                name = nameTemp
            }
            
            if let latTemp = storedPlaces[activePlace!]["lat"]{
                if let lat = Double(latTemp){
                    latitude = lat
                }
            }
            
            if let lonTemp = storedPlaces[activePlace!]["lon"]{
                if let lon = Double(lonTemp){
                    longitude = lon
                }
            }
            
            if name != nil && latitude != nil && longitude != nil{
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                let region = MKCoordinateRegion(center: coordinate, span: span )
                map.setRegion(region, animated: true)
               
                let annotation = MKPointAnnotation()
                annotation.title = name
                annotation.coordinate = coordinate
                map.addAnnotation(annotation)
            }
        } else {
            let storedPlacestemp = UserDefaults.standard.object(forKey: "storedPlaces")
            
            if storedPlacestemp != nil {
                if (storedPlacestemp as! [Dictionary<String, String>]).count > 0{
                    storedPlaces = (storedPlacestemp as? [Dictionary<String, String>])!
                } else {
                    storedPlaces.remove(at: 0)
                }
            }
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        let lpGestureRec = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longPress(gestureRecognizer:)))
        lpGestureRec.minimumPressDuration = 1
        map.addGestureRecognizer(lpGestureRec)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinate = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        map.setRegion(region, animated: true)
    }
    
    
    func longPress(gestureRecognizer: UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = gestureRecognizer.location(in: map)
            let coordinate = map.convert(touchPoint, toCoordinateFrom: map)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error != nil {
                    print("There is ena error" + error.debugDescription)
                } else {
                    var thoroughfare = "No landmark"
                    if let placemark = placemarks?[0]{
                        if let thorFare = placemark.thoroughfare{
                            thoroughfare = thorFare
                        }
                        let annotation = MKPointAnnotation()
                        annotation.title = thoroughfare
                        annotation.coordinate = coordinate
                        self.map.addAnnotation(annotation)
                        self.storedPlaces.append(["name":thoroughfare, "lat":String(coordinate.latitude), "lon":String(coordinate.longitude)])
                        UserDefaults.standard.set(self.storedPlaces, forKey: "storedPlaces")
                        print(self.storedPlaces )
                    }
                }
            })
        }
        
        
    }
}
