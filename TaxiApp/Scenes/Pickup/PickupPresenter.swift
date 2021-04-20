//
//  PickupPresenter.swift
//  TaxiApp
//
//  Created by talgar osmonov on 16/4/21.
//

import UIKit

protocol PickupPresentationLogic {
    func getTrip(trip: Trip)
}

final class PickupPresenter: PickupPresentationLogic {
    
    // MARK: - Public Properties
    
    weak var viewController: PickupDisplayLogic?

    // MARK: - Presentation Logic
    func getTrip(trip: Trip) {
        self.viewController?.getTripResult(trip: trip)
    }
    //
}
