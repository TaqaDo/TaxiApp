//
//  SignUpBuilder.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import UIKit

protocol SignUpBuildingLogic: AnyObject {
  func makeScene(parent: UIViewController?) -> SignUpViewController
}

final class SignUpBuilder: SignUpBuildingLogic {
  
  // MARK: - Public Methods
    
  func makeScene(parent: UIViewController? = nil) -> SignUpViewController {
    let viewController = SignUpViewController()
    
    let interactor = SignUpInteractor()
    let presenter = SignUpPresenter()
    let router = SignUpRouter()

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
