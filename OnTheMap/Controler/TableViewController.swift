//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Segnonna Hounsou on 09/04/2022.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsLocationsModel.studentsLocations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellView")
        
        let studentLocation = StudentsLocationsModel.studentsLocations[indexPath.row]
        
        cell?.textLabel?.text =  "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell?.detailTextLabel?.text =  studentLocation.mediaURL
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocationMediaUrl = StudentsLocationsModel.studentsLocations[indexPath.row].mediaURL
        print(studentLocationMediaUrl)
        let app = UIApplication.shared
        app.open(URL(string: studentLocationMediaUrl)!)
    }
    
    @IBAction func logout(_ sender: Any) {
        OnMapClient.deleteSession { success, error in
            if success {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        viewDidAppear(false)
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
    
    
}
