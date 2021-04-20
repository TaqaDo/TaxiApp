//
//  LoginView.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import SnapKit
import UIKit

protocol LoginViewLogic: UIView {
    func dontHaveAccButton(target: Any, selector: Selector) -> UIButton
    func loginButton(target: Any, selector: Selector) -> UIButton
    func getPassword() -> String
    func getEmail() -> String
}

final class LoginView: UIView {
    
    // MARK: - Views
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = .white
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
       let field = UITextField()
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 16)
        field.textColor = .black
        field.keyboardAppearance = .dark
        field.isSecureTextEntry = true
        field.attributedPlaceholder = NSAttributedString(string: "Password",
                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        return field
    }()
    
    private lazy var emailTextField: UITextField = {
       let field = UITextField()
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 16)
        field.textColor = .black
        field.keyboardAppearance = .dark
        field.attributedPlaceholder = NSAttributedString(string: "Email",
                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        return field
    }()
    
    private lazy var emailTextFieldView: UIView = {
        let view = UIView()
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ic_mail_outline_white_2x")
        imageView.alpha = 0.87
        view.addSubview(imageView)
        imageView.centerY(inView: view)
        imageView.anchor(left: view.leftAnchor, paddingLeft: 8, width: 24, height: 24)
        view.addSubview(emailTextField)
        emailTextField.centerY(inView: view)
        emailTextField.anchor(left: imageView.rightAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        return view
    }()
    
    private lazy var passwordTextFieldView: UIView = {
        let view = UIView()
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        imageView.alpha = 0.87
        view.addSubview(imageView)
        imageView.centerY(inView: view)
        imageView.anchor(left: view.leftAnchor, paddingLeft: 8, width: 24, height: 24)
        view.addSubview(passwordTextField)
        passwordTextField.centerY(inView: view)
        passwordTextField.anchor(left: imageView.rightAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        return view
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        return button
    }()
    
    private lazy var dontHaveAccButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dont have an account? Sign up", for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [emailTextFieldView, passwordTextFieldView, loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        return stack
    }()
    
    //
    
    // MARK: - Init
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Methods
    
    private func configure() {
        backgroundColor = .black
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(dontHaveAccButton)
        addSubview(stackView)
    }
    
    private func addConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeArea.top)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        dontHaveAccButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.safeArea.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - LoginViewLogic

extension LoginView: LoginViewLogic {
    func dontHaveAccButton(target: Any, selector: Selector) -> UIButton {
        dontHaveAccButton.addTarget(target, action: selector, for: .touchUpInside)
        return dontHaveAccButton
    }
    
    func loginButton(target: Any, selector: Selector) -> UIButton {
        loginButton.addTarget(target, action: selector, for: .touchUpInside)
        return loginButton
    }
    
    func getEmail() -> String {
        guard let text = emailTextField.text else {fatalError()}
        return text
    }
    
    func getPassword() -> String {
        guard let text = passwordTextField.text else {fatalError()}
        return text
    }
    
    
}
