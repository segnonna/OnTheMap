//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Segnonna Hounsou on 09/04/2022.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: Credentials
    
    struct Credentials: Codable {
        let username: String
        let password: String
    }
}
