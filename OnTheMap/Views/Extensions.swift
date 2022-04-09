//
//  Extensions.swift
//  OnTheMap
//
//  Created by Segnonna Hounsou on 09/04/2022.
//

import Foundation
import UIKit


extension UIViewController {
    
    static func openAddLocationForm(){
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "openAddLocationForm")
        resultVC.modalPresentationStyle = .fullScreen
        UIViewController.present(resultVC, animated: true)
    }
}
