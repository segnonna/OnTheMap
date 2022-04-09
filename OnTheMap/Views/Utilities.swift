//
//  Utilities.swift
//  OnTheMap
//
//  Created by Segnonna Hounsou on 09/04/2022.
//

import Foundation
import UIKit


func openAddLocationForm(_ controller: UIViewController){
    let storyboard = UIStoryboard (name: "Main", bundle: nil)
    let resultVC = storyboard.instantiateViewController(withIdentifier: "openAddLocationForm")
    resultVC.modalPresentationStyle = .fullScreen
    controller.present(resultVC, animated: true)
}
