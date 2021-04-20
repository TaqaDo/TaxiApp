//
//  InputView.swift
//  TaxiApp
//
//  Created by talgar osmonov on 3/4/21.
//

import SnapKit
import UIKit

protocol LocationInputViewDelegate: class {
    func executeSearch(query: String)
}

protocol LocationInputViewLogic: UIView {
    func backButton(target: Any, selector: Selector) -> UIButton
    func getTitleLabel() -> UILabel
    func setupData(user: User?)
    var delegate: LocationInputViewDelegate? { get set }
}

final class LocationInputView: UIView, LocationInputViewLogic {
    
    weak var delegate: LocationInputViewDelegate?

    // MARK: - Views
    
    private lazy var startLocationTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "  Current location"
        field.backgroundColor = .systemGroupedBackground
        field.isEnabled = false
        field.font = UIFont.systemFont(ofSize: 14)
        return field
    }()
    
    private lazy var destinationLocationTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "  Enter a destination.."
        field.backgroundColor = .lightGray
        field.returnKeyType = .search
        field.delegate = self
        field.font = UIFont.systemFont(ofSize: 14)
        return field
    }()
    
    private lazy var startLocationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 6 / 2
        return view
    }()
    
    private lazy var linkingView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private lazy var destinationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    //
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Methods
    
    private func configure() {
        shadowConfigure()
        addSubviews()
        addConstraints()
    }
    
    private func shadowConfigure() {
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.65
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
    
    private func addSubviews() {
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(startLocationTextField)
        addSubview(destinationLocationTextField)
        addSubview(startLocationIndicatorView)
        addSubview(destinationIndicatorView)
        addSubview(linkingView)
    }
    
    private func addConstraints() {
        
        linkingView.snp.makeConstraints { (make) in
            make.centerX.equalTo(startLocationIndicatorView)
            make.top.equalTo(startLocationIndicatorView.snp.bottom).offset(4)
            make.bottom.equalTo(destinationIndicatorView.snp.top)
            make.width.equalTo(0.5)
        }
        
        destinationIndicatorView.snp.makeConstraints { (make) in
            make.centerY.equalTo(destinationLocationTextField)
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(6)
        }
        
        startLocationIndicatorView.snp.makeConstraints { (make) in
            make.centerY.equalTo(startLocationTextField)
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(6)
        }
        
        startLocationTextField.snp.makeConstraints { (make) in
            make.top.equalTo(backButton.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(30)
        }
        
        destinationLocationTextField.snp.makeConstraints { (make) in
            make.top.equalTo(startLocationTextField.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(30)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(44)
            make.left.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }
    }

    
    func setupData(user: User?) {
        titleLabel.text = user?.fullname
    }
    
    // MARK: - HomeViewLogic
    
    func backButton(target: Any, selector: Selector) -> UIButton {
        backButton.addTarget(target, action: selector, for: .touchUpInside)
        return backButton
    }
    
    func getTitleLabel() -> UILabel {
        return titleLabel
    }
    
}

// MARK: - UITextFieldDelegate

extension LocationInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text else {return false}
        delegate?.executeSearch(query: query)
        return true
    }
}

