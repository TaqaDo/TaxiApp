//
//  LoginInteractor.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import Foundation
import FirebaseAuth

protocol LoginBusinessLogic {
    func signIn(withEmail: String, withPassword: String, completion: @escaping(AuthDataResultCallback))
}

protocol LoginDataStore {
    
}

final class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    
    // MARK: - Public Properties
    
    var presenter: LoginPresentationLogic?
    lazy var worker: LoginWorkingLogic = LoginWorker()

    
    // MARK: - Business Logic
    func signIn(withEmail: String, withPassword: String, completion: @escaping (AuthDataResultCallback)) {
        self.worker.signIn(withEmail: withEmail, withPassword: withPassword, completion: completion)
    }
    //
}
