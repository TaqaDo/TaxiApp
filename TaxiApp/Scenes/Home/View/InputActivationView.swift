//
//  HomeView.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import SnapKit
import UIKit


protocol InputActivationViewLogic: UIView {
    func presentLocationInputView(target: Any, selector: Selector) -> UITapGestureRecognizer
}

final class InputActivationView: UIView {
    
    // MARK: - Views
    
    private lazy var tapGesture = UITapGestureRecognizer()
    
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Where to?"
        label.font = UIFont.systemFont(ofSize: 18)
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
        addGestureRecognizer(tapGesture)
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
        addSubview(indicatorView)
        addSubview(placeholderLabel)
    }
    
    private func addConstraints() {
        indicatorView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.size.equalTo(6)
        }
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(indicatorView.snp.right).offset(16)
        }
    }
}

// MARK: - HomeViewLogic

extension InputActivationView: InputActivationViewLogic {
    func presentLocationInputView(target: Any, selector: Selector) -> UITapGestureRecognizer {
        tapGesture.addTarget(target, action: selector)
        return tapGesture
    }
}
