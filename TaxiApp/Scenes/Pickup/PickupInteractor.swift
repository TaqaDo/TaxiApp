//
//  PickupInteractor.swift
//  TaxiApp
//
//  Created by talgar osmonov on 16/4/21.
//

import Foundation
import Firebase

protocol PickupBusinessLogic {
    func getTrip()
    func acceptTrip(trip: Trip, completion: @escaping(Error?, DatabaseReference) -> Void)
}

protocol PickupDataStore: class {
    var trip: Trip? {get set}
}

final class PickupInteractor: PickupBusinessLogic, PickupDataStore {
    
    // MARK: - Public Properties
    
    var presenter: PickupPresentationLogic?
    lazy var worker: PickupWorkingLogic = PickupWorker()
    var trip: Trip?
    
    // MARK: - Business Logic
    func getTrip() {
        guard let trip = trip else {return}
        self.presenter?.getTrip(trip: trip)
    }
    
    func acceptTrip(trip: Trip, completion: @escaping (Error?, DatabaseReference) -> Void) {
        self.worker.acceptTrip(trip: trip, completion: completion)
    }
    //
}
