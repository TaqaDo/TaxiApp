//
//  HomePresenter.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import UIKit

protocol HomePresentationLogic {
    func fetchUserData(user: User)
    func fetchDrivers(user: User)
    func observeTrips(trip: Trip)
    func observeCurrentTrip(trip: Trip)
}

final class HomePresenter: HomePresentationLogic {
    
    // MARK: - Public Properties
    
    weak var viewController: HomeDisplayLogic?

    // MARK: - Presentation Logic
    func fetchUserData(user: User) {
        self.viewController?.fetchUserDataResult(user: user)
    }
    
    func fetchDrivers(user: User) {
        self.viewController?.fetchDriversResult(driver: user)
    }
    
    func observeTrips(trip: Trip) {
        self.viewController?.observeTripResult(trip: trip)
    }
    func observeCurrentTrip(trip: Trip) {
        self.viewController?.observeCurrentTripResult(trip: trip)
    }
    //
}
