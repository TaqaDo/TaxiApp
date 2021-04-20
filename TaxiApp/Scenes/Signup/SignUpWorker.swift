//
//  SignUpWorker.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol SignUpWorkingLogic {
    func createUser(withEmail: String, password: String, completion: @escaping(AuthDataResultCallback))
    func setUserToDataBase(uid: String, withValues: [String : Any], completion: @escaping(Error?, DatabaseReference) -> Void)
}

final class SignUpWorker: SignUpWorkingLogic {
    
    // MARK: - Private Properties
    
    //
    
    // MARK: - Working Logic
    func createUser(withEmail: String, password: String, completion: @escaping (AuthDataResultCallback)) {
        Auth.auth().createUser(withEmail: withEmail, password: password, completion: completion)
    }
    
    func setUserToDataBase(uid: String, withValues: [String : Any], completion: @escaping (Error?, DatabaseReference) -> Void) {
        Database.database().reference().child("users").child(uid).updateChildValues(withValues, withCompletionBlock: completion)
    }
    //
}
