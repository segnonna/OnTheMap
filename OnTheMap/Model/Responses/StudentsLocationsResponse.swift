//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Segnonna Hounsou on 09/04/2022.
//

import Foundation

struct StudentsLocationsResponse: Codable{
    let results: [StudentLocation]
    
    struct StudentLocation: Codable {
        let objectId: String
        let uniqueKey: String
        let firstName: String
        let lastName: String
        let mapString: String
        let mediaURL: String
        let latitude: Double
        let longitude: Double
        let createdAt: String
        let updatedAt: String
    }
}
