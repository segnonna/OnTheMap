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
    
    @IBAction func closeScreen(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        if (!(addressTextField?.text?.isEmpty ?? false)  && !(mediaUrl?.text?.isEmpty ?? false)) {
            print(OnMapClient.Sessions.sessionId)
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let resultVC = storyboard.instantiateViewController(withIdentifier: "MyCurrentLocationMapViewController") as! MyCurrentLocationMapViewController
            resultVC.address = addressTextField?.text ?? "USA"
            resultVC.mediaUrl = mediaUrl?.text ?? "http://www.google.com"
            self.navigationController?.pushViewController(resultVC, animated: true)
        } else {
            let alertVC = UIAlertController(title: "Error", message: "You must fill out all the fileds", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.navigationController?.topViewController?.present(alertVC, animated: true)
        }
    }
    
}
