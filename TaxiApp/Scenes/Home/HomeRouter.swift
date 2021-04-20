//
//  HomeRouter.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import UIKit

protocol HomeRoutingLogic {
    func navigateToLogin()
    func navigateToPickup(trip: Trip, delegate: PickupViewControllerDelegate)
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

final class HomeRouter: HomeRoutingLogic, HomeDataPassing {
    
    // MARK: - Public Properties
    
    weak var parentController: UIViewController?
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
    
    // MARK: - Private Properties
    
    //
    
    // MARK: - Routing Logic
    func navigateToLogin() {
        let loginVC = LoginBuilder().makeScene()
        self.viewController?.navigationController?.pushViewController(loginVC, animated: false)
    }
    
    func navigateToPickup(trip: Trip, delegate: PickupViewControllerDelegate) {
        let pickVC = PickupBuilder().makeScene()
        pickVC.router?.dataStore?.trip = trip
        pickVC.delegate = delegate
        pickVC.modalPresentationStyle = .fullScreen
        self.viewController?.navigationController?.present(pickVC, animated: true, completion: nil)
    }
    //

}
