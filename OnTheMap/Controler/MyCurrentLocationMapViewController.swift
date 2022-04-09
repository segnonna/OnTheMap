//
//  MyCurrentLocationMapViewController.swift
//  OnTheMap
//
//  Created by Segnonna Hounsou on 09/04/2022.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MyCurrentLocationMapViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    
    var address: String = ""
    var mediaUrl:String = ""
    
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocation(from: address) { location in
            let annotation = MKPointAnnotation()
            self.latitude = location?.latitude ?? 0.0
            self.longitude = location?.longitude ?? 0.0
            
            let coord = CLLocationCoordinate2D(latitude: OnMapClient.Sessions.latitude, longitude: OnMapClient.Sessions.longitude)
            annotation.coordinate = coord
            annotation.title = self.address
            
            self.mapView.addAnnotation(annotation)
            self.mapView.centerCoordinate = coord
        }    }
    
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location?.coordinate else {
                completion(nil)
                return
            }
            completion(location)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    @IBAction func closeScreen(_ sender: Any) {
        
        OnMapClient.addOrUpdateMyPosition(mediaURL: mediaUrl,
                                          latitude: self.latitude,
                                          longitude: self.longitude,
                                  mapString: address) { success, error in
            if success {
                OnMapClient.Sessions.latitude = self.latitude
                OnMapClient.Sessions.longitude = self.latitude
                self.dismiss(animated: true)
            } else {
                let alertVC = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.navigationController?.topViewController?.present(alertVC, animated: true)
            }
        }

    }
    
}
