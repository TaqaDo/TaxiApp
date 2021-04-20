//
//  PickupBuilder.swift
//  TaxiApp
//
//  Created by talgar osmonov on 16/4/21.
//

import UIKit

protocol PickupBuildingLogic: AnyObject {
  func makeScene(parent: UIViewController?) -> PickupViewController
}

final class PickupBuilder: PickupBuildingLogic {
  
  // MARK: - Public Methods
    
  func makeScene(parent: UIViewController? = nil) -> PickupViewController {
    let viewController = PickupViewController()
    
    let interactor = PickupInteractor()
    let presenter = PickupPresenter()
    let router = PickupRouter()

    interactor.presenter = presenter
    presenter.viewController = viewController
    
    router.parentController = parent
    router.viewController = viewController
    router.dataStore = interactor

    viewController.interactor = interactor
    viewController.router = router
    
    return viewController
  }
}
