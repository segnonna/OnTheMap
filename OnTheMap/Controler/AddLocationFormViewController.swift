//
//  AddLocationFormViewController.swift
//  OnTheMap
//
//  Created by Segnonna Hounsou on 09/04/2022.
//

import Foundation
import UIKit
import CoreLocation

class AddLocationFormViewController : UIViewController{
    
    @IBOutlet var addressTextField: UITextField!
    
    @IBOutlet var mediaUrl: UITextField!
    
    private var latitude: Double = 0.0
    
    private var longitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocation(from: addressTextField.text ?? "") { location in
            self.latitude = location?.latitude ?? 0.0
            self.longitude = location?.longitude ?? 0.0
        }    }
    
    @IBAction func closeScreen(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        if (!(addressTextField?.text?.isEmpty ?? false)  && !(mediaUrl?.text?.isEmpty ?? false)) {
            print(OnMapClient.Sessions.sessionId)
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let resultVC = storyboard.instantiateViewController(withIdentifier: "MyCurrentLocationMapViewController") as! MyCurrentLocationMapViewController
            resultVC.address = addressTextField?.text ?? "USA"
            resultVC.mediaUrl = mediaUrl?.text ?? "http://www.google.com"
            resultVC.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.navigationController?.pushViewController(resultVC, animated: true)
        } else {
            let alertVC = UIAlertController(title: "Error", message: "You must fill out all the fileds", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.navigationController?.topViewController?.present(alertVC, animated: true)
        }
    }
    
    private func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
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
    
}
