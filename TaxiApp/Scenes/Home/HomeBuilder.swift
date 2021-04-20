//
//  HomeBuilder.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import UIKit

protocol HomeBuildingLogic: AnyObject {
  func makeScene(parent: UIViewController?) -> HomeViewController
}

final class HomeBuilder: HomeBuildingLogic {
  
  // MARK: - Public Methods
    
  func makeScene(parent: UIViewController? = nil) -> HomeViewController {
    let viewController = HomeViewController()
    
    let interactor = HomeInteractor()
    let presenter = HomePresenter()
    let router = HomeRouter()

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
