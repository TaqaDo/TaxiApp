//
//  LoginWorker.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import Foundation
import FirebaseAuth

protocol LoginWorkingLogic {
    func signIn(withEmail: String, withPassword: String, completion: @escaping(AuthDataResultCallback))
}

final class LoginWorker: LoginWorkingLogic {

    
    // MARK: - Working Logic
    func signIn(withEmail: String, withPassword: String, completion: @escaping (AuthDataResultCallback)) {
        Auth.auth().signIn(withEmail: withEmail, password: withPassword, completion: completion)
    }
    //
}
