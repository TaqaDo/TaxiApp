//
//  HomeWorker.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import Foundation
import Firebase
import GeoFire

protocol HomeWorkingLogic {
    func isLogedin() -> Bool
    func fetchUserData(uid: String, completion: @escaping(_ user: User) -> Void)
    func fetchDrivers(location: CLLocation, completion: @escaping(User) -> Void)
    func uploadTrip(pickupCoordinates: CLLocationCoordinate2D,
                    destinationCoordinates: CLLocationCoordinate2D,
                    completion: @escaping(Error?, DatabaseReference) -> Void)
    func observeTrips(completion: @escaping(Trip) -> Void)
    func observeCurrentTrip(completion: @escaping(Trip) -> Void)
    func fetchPersoneData(uid: String, completion: @escaping(_ user: User) -> Void)
}

final class HomeWorker: HomeWorkingLogic {
    
    // MARK: - Private Properties
    
    //
    
    // MARK: - Working Logic
    
    func fetchPersoneData(uid: String, completion: @escaping (User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
 
        }
    }
    
    func isLogedin() -> Bool {
        if Auth.auth().currentUser?.uid != nil {
            return true
        } else {
            return false
        }
    }
    
    func fetchUserData(uid: String, completion: @escaping(_ user: User) -> Void) {
       
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
 
        }
    }
    
    func fetchDrivers(location: CLLocation, completion: @escaping(User) -> Void) {
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        REF_DRIVER_LOCATIONS.observe(.value) { (snapshot) in
            geofire.query(at: location, withRadius: 50).observe(.keyEntered, with: { (uid, location) in
                self.fetchUserData(uid: uid) { (user) in
                    var driver = user
                    driver.location = location
                    completion(driver)
                }
            })
        }
    }
    
    func uploadTrip(pickupCoordinates: CLLocationCoordinate2D, destinationCoordinates: CLLocationCoordinate2D, completion: @escaping (Error?, DatabaseReference) -> Void) {
        
        guard let uid = currentUID else {return}
        let pickupArray = [pickupCoordinates.latitude, pickupCoordinates.longitude]
        let destinationArray = [destinationCoordinates.latitude, destinationCoordinates.longitude]
        
        let values = ["pickupCoordinates" : pickupArray,
                      "destinationCoordinates" : destinationArray,
                      "state" : TripState.requested.rawValue] as [String : Any]
        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func observeTrips(completion: @escaping(Trip) -> Void) {
        REF_TRIPS.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let uid = snapshot.key
            let trip = Trip(passengerUid: uid, dictionary: dictionary)
            completion(trip)
        }
    }
    
    func observeCurrentTrip(completion: @escaping (Trip) -> Void) {
        guard let uid = currentUID else {return}
        
        REF_TRIPS.child(uid).observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let uid = snapshot.key
            let trip = Trip(passengerUid: uid, dictionary: dictionary)
            completion(trip)
        }
    }

    //
}
