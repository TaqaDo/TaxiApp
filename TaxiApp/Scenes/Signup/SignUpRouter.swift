//
//  SignUpRouter.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import UIKit

protocol SignUpRoutingLogic {
    func popUpToLogin()
}

protocol SignUpDataPassing {
    var dataStore: SignUpDataStore? { get }
}

final class SignUpRouter: SignUpRoutingLogic, SignUpDataPassing {
    
    // MARK: - Public Properties
    
    weak var parentController: UIViewController?
    weak var viewController: SignUpViewController?
    var dataStore: SignUpDataStore?
    
    // MARK: - Private Properties
    
    //
    
    // MARK: - Routing Logic
    func popUpToLogin() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    //
}
