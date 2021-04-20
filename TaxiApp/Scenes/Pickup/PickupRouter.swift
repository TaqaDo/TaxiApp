//
//  PickupRouter.swift
//  TaxiApp
//
//  Created by talgar osmonov on 16/4/21.
//

import UIKit

protocol PickupRoutingLogic {

}

protocol PickupDataPassing {
  var dataStore: PickupDataStore? { get }
}

final class PickupRouter: PickupRoutingLogic, PickupDataPassing {

  // MARK: - Public Properties

  weak var parentController: UIViewController?
  weak var viewController: PickupViewController?
  weak var dataStore: PickupDataStore?
  
  // MARK: - Private Properties
  
  //

  // MARK: - Routing Logic
  
  //

  // MARK: - Navigation
  
  //

  // MARK: - Passing data
  
  //
}
