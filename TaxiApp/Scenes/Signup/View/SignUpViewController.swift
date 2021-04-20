//
//  SignUpViewController.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import UIKit
import FirebaseAuth
import GeoFire

protocol SignUpDisplayLogic: AnyObject {
    
}

final class SignUpViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var interactor: SignUpBusinessLogic?
    var router: (SignUpRoutingLogic & SignUpDataPassing)?
    lazy var contentView: SignUpViewLogic = SignUpView()
    
    // MARK: - Private Properties
    
    private var location = LocationHandler.shared.locationManager.location
    //
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureNav()
    }
    
    
    // MARK: - Requests
    private func createUser() {
        self.interactor?.createUser(withEmail: contentView.getEmail(), password: contentView.getPassword(), completion: { (result, error) in
            if let error = error {
                print("Create error \(error.localizedDescription)")
                return
            }
            guard let uid = result?.user.uid else {return}
            let values = ["email" : self.contentView.getEmail(), "fullname" : self.contentView.getFullname(), "accountType" : self.contentView.getSegmentedControll().selectedSegmentIndex] as [String : Any]
            
            if self.contentView.getSegmentedControll().selectedSegmentIndex == 1 {
                
                let geoFire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
                let sharedLocationManager = LocationHandler.shared.locationManager
                guard let location = self.location else {return}
                
                geoFire.setLocation(location, forKey: uid) { (error) in
                    self.setUserToDatabase(uid: uid, withValues: values)
                }
            }
            
            self.setUserToDatabase(uid: uid, withValues: values)
            
        })
    }
    
    private func setUserToDatabase(uid: String, withValues: [String : Any]) {
        self.interactor?.setUserToDataBase(uid: uid, withValues: withValues, completion: { (error, ref) in
            if let error = error {
                print("error \(error.localizedDescription)")
                return
            }
            
            self.router?.popUpToLogin()
        })
    }
    //
    
    // MARK: - Private Methods
    
    private func configure() {
        contentView.alreadyHaveAccButton(target: self, selector: #selector(goToLogin))
        contentView.signUpButton(target: self, selector: #selector(handleSignUp))
    }
    
    private func configureNav() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    
    // MARK: - UI Actions
    
    @objc func goToLogin() {
        self.router?.popUpToLogin()
    }
    
    @objc func handleSignUp() {
        self.createUser()
    }
    
    //
}

// MARK: - Display Logic

extension SignUpViewController: SignUpDisplayLogic {
    
}
