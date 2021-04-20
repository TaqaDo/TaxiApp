//
//  LoginBuilder.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import UIKit

protocol LoginBuildingLogic: AnyObject {
  func makeScene(parent: UIViewController?) -> LoginViewController
}

final class LoginBuilder: LoginBuildingLogic {
  
  // MARK: - Public Methods
    
  func makeScene(parent: UIViewController? = nil) -> LoginViewController {
    let viewController = LoginViewController()
    
    let interactor = LoginInteractor()
    let presenter = LoginPresenter()
    let router = LoginRouter()

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
