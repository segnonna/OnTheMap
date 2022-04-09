//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Segnonna Hounsou on 09/04/2022.
//

import Foundation

struct LoginResponse: Codable {
    var session: LoginSession
    var account: Account
    
    struct LoginSession: Codable {
        var id :String
        var expiration: String
    }
    
    struct Account: Codable {
        var registered :Bool
        var key: String
    }
}
