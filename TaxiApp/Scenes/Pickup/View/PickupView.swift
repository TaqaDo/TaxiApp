//
//  PickupView.swift
//  TaxiApp
//
//  Created by talgar osmonov on 16/4/21.
//

import SnapKit
import UIKit

protocol PickupViewLogic: UIView {
    func cancelButton(target: Any, selector: Selector) -> UIButton
    func acceptTripButton(target: Any, selector: Selector) -> UIButton
}

final class PickupView: UIView {
    
    // MARK: - Views
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_clear_white_36pt_2x").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private lazy var acceptTripButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("ACCEPT TRIP", for: .normal)
        return button
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
        addSubview(cancelButton)
        addSubview(acceptTripButton)
    }
    
    private func addConstraints() {
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeArea.top).inset(22)
            make.leading.equalToSuperview().inset(16)
        }
        
        acceptTripButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(44)
            make.height.equalTo(55)
        }
    }
}

// MARK: - PickupViewLogic

extension PickupView: PickupViewLogic {
    func cancelButton(target: Any, selector: Selector) -> UIButton {
        cancelButton.addTarget(target, action: selector, for: .touchUpInside)
        return cancelButton
    }
    
    func acceptTripButton(target: Any, selector: Selector) -> UIButton {
        acceptTripButton.addTarget(target, action: selector, for: .touchUpInside)
        return acceptTripButton
    }
}
