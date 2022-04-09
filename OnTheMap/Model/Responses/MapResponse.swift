//
//  MapResponse.swift
//  OnTheMap
//
//  Created by Segnonna Hounsou on 09/04/2022.
//

import Foundation

struct MapResponse: Codable {
    let status: Int
    let error: String
}

extension MapResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
