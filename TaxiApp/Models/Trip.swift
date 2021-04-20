//
//  Trip.swift
//  TaxiApp
//
//  Created by talgar osmonov on 15/4/21.
//

import Foundation
import CoreLocation

enum TripState: Int {
    case requested
    case isAccepted
    case driverArrived
    case inProgress
    case isCompleted
}


struct Trip {
    var pickupCoordiantes: CLLocationCoordinate2D!
    var destinationCoordinates: CLLocationCoordinate2D!
    let passengerUid: String!
    let driverUid: String?
    var state: TripState!
    
    init(passengerUid: String, dictionary: [String : Any]) {
        self.passengerUid = passengerUid
        self.driverUid = dictionary["driverUid"] as? String ?? ""
        
        if let pickupCoordinates = dictionary["pickupCoordinates"] as? NSArray {
            guard let lat = pickupCoordinates[0] as? CLLocationDegrees else {return}
            guard let long = pickupCoordinates[1] as? CLLocationDegrees else {return}
            self.pickupCoordiantes = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        if let destinationCoordinates = dictionary["destinationCoordinates"] as? NSArray {
            guard let lat = destinationCoordinates[0] as? CLLocationDegrees else {return}
            guard let long = destinationCoordinates[1] as? CLLocationDegrees else {return}
            self.destinationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        if let state = dictionary["state"] as? Int {
            self.state = TripState(rawValue: state)
        }
        
    }
}

