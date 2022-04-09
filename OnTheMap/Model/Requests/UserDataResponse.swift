//
//  UserDataResponse.swift
//  OnTheMap
//
//  Created by Segnonna Hounsou on 09/04/2022.
//

import Foundation

struct UserDataResponse: Codable {
    let lastName: String
    let firstName: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
    }
}
