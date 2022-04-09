//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Segnonna Hounsou on 09/04/2022.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var loader: UIActivityIndicatorView!
    
    @IBOutlet var erroLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        erroLabel.isHidden = true
        showHideMap(isLoading: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
        
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        OnMapClient.deleteSession { success, error in
            if success {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func refreshData(_ sender: Any) {
        loadData()
    }
    
    @IBAction func addMyLocation(_ sender: Any) {
        if OnMapClient.Sessions.latitude.isZero {
           openAddLocationForm(self)
        }else {
            let alertVC = UIAlertController(title: "", message: "You have already posted a student location. Would  you like to overwrite yout current location?", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { [self](alert: UIAlertAction!) in
                openAddLocationForm(self)
            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.navigationController?.topViewController?.present(alertVC, animated: true)
        }
    }
    
    private func showHideMap(isLoading: Bool){
        mapView.isHidden = isLoading
        loader.isHidden = !isLoading
        if isLoading {
            loader.startAnimating()
        }
        else {
            loader.stopAnimating()
        }
    }
    
    private func loadData(){
        OnMapClient.fetchStudentsLocations { locations, error in
            if !locations.isEmpty {
                self.showHideMap(isLoading: false)
                self.erroLabel.isHidden = false
                var annotations = [MKPointAnnotation]()
                
                StudentsLocationsModel.studentsLocations.removeAll()
                locations.forEach { studendLocation in
                    let lat = CLLocationDegrees(studendLocation.latitude)
                    let long = CLLocationDegrees(studendLocation.longitude)
                
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = studendLocation.firstName
                    let last = studendLocation.lastName
                    let mediaURL = studendLocation.mediaURL
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                
                    
                    if(!mediaURL.isEmpty && lat != 0.0 && long != 0.0 && !first.isEmpty && !last.isEmpty  ){
                        annotations.append(annotation)
                        StudentsLocationsModel.studentsLocations.append(studendLocation)
                    }
                
                }

                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                self.mapView.addAnnotations(annotations)
            } else {
                self.erroLabel.isHidden = false
            }
            
            if let error = error {
                let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.navigationController?.topViewController?.present(alertVC, animated: true)
            }

        }
    }
    
}
