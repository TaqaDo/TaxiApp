//
//  SignUpInteractor.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol SignUpBusinessLogic {
    func createUser(withEmail: String, password: String, completion: @escaping(AuthDataResultCallback))
    func setUserToDataBase(uid: String, withValues: [String : Any], completion: @escaping(Error?, DatabaseReference) -> Void)
}

protocol SignUpDataStore {
    
}

final class SignUpInteractor: SignUpBusinessLogic, SignUpDataStore {
    
    // MARK: - Public Properties
    
    var presenter: SignUpPresentationLogic?
    lazy var worker: SignUpWorkingLogic = SignUpWorker()
    
    
    // MARK: - Business Logic
    func createUser(withEmail: String, password: String, completion: @escaping ((AuthDataResult?, Error?) -> Void)) {
        self.worker.createUser(withEmail: withEmail, password: password, completion: completion)
    }
    
    func setUserToDataBase(uid: String, withValues: [String : Any], completion: @escaping (Error?, DatabaseReference) -> Void) {
        self.worker.setUserToDataBase(uid: uid, withValues: withValues, completion: completion)
    }
    //
}
