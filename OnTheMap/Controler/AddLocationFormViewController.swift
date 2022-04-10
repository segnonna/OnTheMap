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
    
    @IBOutlet var loader: UIActivityIndicatorView!
    
    @IBOutlet var findButton: UIButton!
    
    private var latitude: Double = 0.0
    
    private var longitude: Double = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loader.isHidden = true
    }
    
    @IBAction func closeScreen(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        if ((self.addressTextField?.text?.isEmpty ?? false)  && (self.mediaUrl?.text?.isEmpty ?? false)) {
            self.showAlert(message: "You must fill out all the fileds")
        }
        else {
            geocodeLoading(isLoading: true)
            getLocation(from: addressTextField.text ?? "") { location in
                self.geocodeLoading(isLoading: false)
                
                guard let location = location else {
                    self.showAlert(message: "Unable to get your current location")
                    return
                }
                print(OnMapClient.Sessions.sessionId)
                let storyboard = UIStoryboard (name: "Main", bundle: nil)
                let resultVC = storyboard.instantiateViewController(withIdentifier: "MyCurrentLocationMapViewController") as! MyCurrentLocationMapViewController
                resultVC.address = self.addressTextField?.text ?? "USA"
                resultVC.mediaUrl = self.mediaUrl?.text ?? "http://www.google.com"
                resultVC.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                self.navigationController?.pushViewController(resultVC, animated: true)
                
            }
        }
        
    }
    
    private func showAlert (message: String){
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        navigationController?.topViewController?.present(alertVC, animated: true)
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
    
    private func geocodeLoading(isLoading: Bool){
        addressTextField.isEnabled = !isLoading
        mediaUrl.isEnabled = !isLoading
        findButton.isEnabled = !isLoading
        loader.isHidden = !isLoading
        
        if isLoading {loader.startAnimating()} else {
            loader.stopAnimating()
        }
    }
}
