//
//  RideActionView.swift
//  TaxiApp
//
//  Created by talgar osmonov on 14/4/21.
//

import SnapKit
import UIKit
import MapKit


protocol RideActionViewLogic: UIView {
    func getActionButton(target: Any, selector: Selector) -> UIButton
    func setupData(destination: MKPlacemark?)
    func configureRideActionView(withConfig config: RideActionViewConfiguration)
    var user: User? {get set}
    func getActions() -> ButtonAction
}

enum RideActionViewConfiguration {
    case requestRide
    case tripAccepted
    case driverArrived
    case pickupPassenger
    case tripInProgress
    case endTrip
    
    init() {
        self = .requestRide
    }
}

enum ButtonAction: CustomStringConvertible {
    case requestRide
    case cancel
    case getDirections
    case pickup
    case dropOff
    
    var description: String {
        switch self {
        case .requestRide:
            return "CONFIRM UBERX"
        case .cancel:
            return "CANCEL RIDE"
        case .getDirections:
            return "GET DIRECTIONS"
        case .pickup:
            return "PICKUP PASSENGER"
        case .dropOff:
            return "DROP OFF PASSENGER"
        }
    }
    
    init() {
        self = .requestRide
    }
}

final class RideActionView: UIView {
    
    var config = RideActionViewConfiguration()
    var buttonAction = ButtonAction()
    var user: User?
    
    // MARK: - Views
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Test Coffee Shop"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Test Coffee Shop Address"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CONFIRM UBERX", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        return stack
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
    
    private func shadowConfigure() {
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.65
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
    
    private func configure() {
        backgroundColor = .white
        shadowConfigure()
        addSubviews()
        addConstraints()
    }
    
    
    private func addSubviews() {
        addSubview(stackView)
        addSubview(actionButton)
    }
    
    private func addConstraints() {
        stackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(12)
        }
        actionButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(22)
            make.bottom.equalToSuperview().inset(42)
            make.height.equalTo(50)
        }
    }
}

// MARK: - HomeViewLogic

extension RideActionView: RideActionViewLogic {
    
    func getActions() -> ButtonAction {
        return buttonAction
    }
    
    func getActionButton(target: Any, selector: Selector) -> UIButton {
        actionButton.addTarget(target, action: selector, for: .touchUpInside)
        return actionButton
    }
    
    func setupData(destination: MKPlacemark?) {
        titleLabel.text = destination?.name
        addressLabel.text = destination?.address
    }

    
    func configureRideActionView(withConfig config: RideActionViewConfiguration) {
        
        switch config {
        
        case .requestRide:
            buttonAction = .requestRide
            actionButton.setTitle(buttonAction.description, for: .normal)
        case .tripAccepted:
            
            if user?.accountType == .passenger {
                titleLabel.text = "En Route to Passenger"
                buttonAction = .getDirections
                actionButton.setTitle(buttonAction.description, for: .normal)
            } else {
                titleLabel.text = "Driver En Route"
                buttonAction = .cancel
                actionButton.setTitle(buttonAction.description, for: .normal)
            }
            
            addressLabel.text = user?.fullname
            
        case .driverArrived:
            guard let user = user else {return}
            
            if user.accountType == .driver {
                titleLabel.text = "Driver Has Arrived"
                addressLabel.text = "Meet a Driver PLS"
                
            }
            
        case .pickupPassenger:
            titleLabel.text = "Arrived at PAssenger Location"
            buttonAction = .pickup
            actionButton.setTitle(buttonAction.description, for: .normal)
        case .tripInProgress:
            if user?.accountType == .driver {
                actionButton.setTitle("TRIP IN PROGRESS", for: .normal)
                actionButton.isEnabled = false
            } else {
                buttonAction = .getDirections
                actionButton.setTitle(buttonAction.description, for: .normal)
            }
            
            titleLabel.text = "EN Rout To Destination"
        case .endTrip:
            if user?.accountType == .driver {
                actionButton.setTitle("ARRIVED AT DESTINATION", for: .normal)
                actionButton.isEnabled = false
            } else {
                buttonAction = .dropOff
                actionButton.setTitle(buttonAction.description, for: .normal)
            }
        }
    }
}

