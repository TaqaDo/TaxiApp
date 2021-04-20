//
//  HomeInteractor.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import Foundation
import GeoFire
import Firebase


protocol HomeBusinessLogic {
    func isLogedin() -> Bool
    func fetchUserData(uid: String)
    func fetchDrivers(location: CLLocation)
    func uploadTrip(pickupCoordinates: CLLocationCoordinate2D,
                    destinationCoordinates: CLLocationCoordinate2D,
                    completion: @escaping(Error?, DatabaseReference) -> Void)
    func observeTrips()
    func observeCurrentTrip()
    func fetchPersoneData(uid: String, completion: @escaping (User) -> Void)
    func cancelTrip(completion: @escaping(Error?, DatabaseReference) -> Void)
    func observeTripCanceled(trip: Trip, completion: @escaping() -> Void)
    func updateDriverLocation(location: CLLocation)
    func updateTripState(trip: Trip, state: TripState)
}

protocol HomeDataStore {
    
}

final class HomeInteractor: HomeBusinessLogic, HomeDataStore {
    
    // MARK: - Public Properties
    
    var presenter: HomePresentationLogic?
    lazy var worker: HomeWorkingLogic = HomeWorker()

    // MARK: - Business Logic
    
    func updateTripState(trip: Trip, state: TripState) {
        REF_TRIPS.child(trip.passengerUid).child("state").setValue(state.rawValue)
    }
    
    func updateDriverLocation(location: CLLocation) {
        guard let uid = currentUID else {return}
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        geofire.setLocation(location, forKey: uid)
    }
    
    func observeTripCanceled(trip: Trip, completion: @escaping () -> Void) {
        REF_TRIPS.child(trip.passengerUid).observeSingleEvent(of: .childRemoved) { (_) in
            completion()
        }
    }
    
    func cancelTrip(completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let uid = currentUID else {return}
        REF_TRIPS.child(uid).removeValue(completionBlock: completion)

    }
    
    func fetchPersoneData(uid: String, completion: @escaping (User) -> Void) {
        self.worker.fetchPersoneData(uid: uid, completion: completion)
    }
    
    func isLogedin() -> Bool {
        if self.worker.isLogedin() {
            return true
        } else {
            return false
        }
    }
    
    func fetchUserData(uid: String) {
        self.worker.fetchUserData(uid: uid) { (user) in
            self.presenter?.fetchUserData(user: user)
        }
    }
    
    func fetchDrivers(location: CLLocation) {
        self.worker.fetchDrivers(location: location) { (user) in
            self.presenter?.fetchDrivers(user: user)
        }
    }
    
    func uploadTrip(pickupCoordinates: CLLocationCoordinate2D, destinationCoordinates: CLLocationCoordinate2D, completion: @escaping (Error?, DatabaseReference) -> Void) {
        self.worker.uploadTrip(pickupCoordinates: pickupCoordinates, destinationCoordinates: destinationCoordinates, completion: completion)
    }
    
    func observeTrips() {
        self.worker.observeTrips { (trip) in
            self.presenter?.observeTrips(trip: trip)
        }
    }
    func observeCurrentTrip() {
        self.worker.observeCurrentTrip { (trip) in
            self.presenter?.observeCurrentTrip(trip: trip)
        }
    }
    //
}
