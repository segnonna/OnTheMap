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
    
    @IBOutlet var loader: UIActivityIndicatorView!
    
    @IBOutlet var finishButton: UIButton!
    
    private let locationManager = CLLocationManager()
    
    var address: String = ""
    var mediaUrl:String = ""
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showOrHideMap(isLoading: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = self.address
        
        self.mapView.addAnnotation(annotation)
        self.mapView.centerCoordinate = coordinate
        
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
        showOrHideMap(isLoading: true)
        OnMapClient.addOrUpdateMyPosition(mediaURL: mediaUrl,
                                          latitude: coordinate.latitude,
                                          longitude: coordinate.longitude,
                                          mapString: address) { success, error in
            self.showOrHideMap(isLoading: false)
            if success {
                OnMapClient.Sessions.latitude = self.coordinate.latitude
                OnMapClient.Sessions.longitude = self.coordinate.longitude
                self.dismiss(animated: true)
            } else {
                let alertVC = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.navigationController?.topViewController?.present(alertVC, animated: true)
            }
        }
        
    }
    
    private func showOrHideMap(isLoading: Bool){
        mapView.isHidden = isLoading
        loader.isHidden = !isLoading
        finishButton.isHidden = isLoading
        if isLoading {loader.startAnimating()} else {
            loader.stopAnimating()
        }
    }
}
