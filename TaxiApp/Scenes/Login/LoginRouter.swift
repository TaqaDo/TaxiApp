//
//  LoginRouter.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import UIKit

protocol LoginRoutingLogic {
    func navigateToSignUp()
    func navigateToHome()
}

protocol LoginDataPassing {
  var dataStore: LoginDataStore? { get }
}

final class LoginRouter: LoginRoutingLogic, LoginDataPassing {

  // MARK: - Public Properties

  weak var parentController: UIViewController?
  weak var viewController: LoginViewController?
  var dataStore: LoginDataStore?
  
  // MARK: - Private Properties
  
  //

  // MARK: - Routing Logic
    func navigateToSignUp() {
        let signUpVC = SignUpBuilder().makeScene()
        self.viewController?.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    func navigateToHome() {
        let homeVC = HomeBuilder().makeScene()
        self.viewController?.navigationController?.popToRootViewController(animated: false)
    }
  //

}
