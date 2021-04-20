//
//  LoginViewController.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import UIKit

protocol LoginDisplayLogic: AnyObject {
    
}

final class LoginViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var interactor: LoginBusinessLogic?
    var router: (LoginRoutingLogic & LoginDataPassing)?
    
    lazy var contentView: LoginViewLogic = LoginView()
    
    // MARK: - Private Properties
    
    //
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableBackSwipe()
        configure()
        configureNav()  
    }
    
    // MARK: - Requests
    
    private func signIn() {
        self.interactor?.signIn(withEmail: contentView.getEmail(), withPassword: contentView.getPassword(), completion: { (result, error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
                return
            } else {
                self.router?.navigateToHome()
            }
        })
    }
    //
    
    // MARK: - Private Methods
    
    private func configure() {
        contentView.dontHaveAccButton(target: self, selector: #selector(goToSignUp))
        contentView.loginButton(target: self, selector: #selector(handleLogin))
    }
    
    private func configureNav() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    private func disableBackSwipe() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    // MARK: - UI Actions
    
    @objc func goToSignUp() {
        self.router?.navigateToSignUp()
    }
    
    @objc func handleLogin() {
        self.signIn()
    }
    
    //
}

// MARK: - Display Logic

extension LoginViewController: LoginDisplayLogic {
    
}
