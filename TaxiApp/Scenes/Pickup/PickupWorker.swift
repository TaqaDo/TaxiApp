//
//  PickupWorker.swift
//  TaxiApp
//
//  Created by talgar osmonov on 16/4/21.
//

import Foundation
import Firebase

protocol PickupWorkingLogic {
    func acceptTrip(trip: Trip, completion: @escaping(Error?, DatabaseReference) -> Void)
}

final class PickupWorker: PickupWorkingLogic {
    
    // MARK: - Private Properties
    
    //
    
    // MARK: - Working Logic
    
    func acceptTrip(trip: Trip, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let uid = currentUID else {return}
        
        let values = ["driverUid" : uid, "state" : TripState.isAccepted.rawValue] as [String : Any]
        
        REF_TRIPS.child(trip.passengerUid).updateChildValues(values, withCompletionBlock: completion)
    }
    //
}
