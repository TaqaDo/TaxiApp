//
//  PickupViewController.swift
//  TaxiApp
//
//  Created by talgar osmonov on 16/4/21.
//

import UIKit
import MapKit

protocol PickupViewControllerDelegate: class {
    func didAccepted(trip: Trip)
}

protocol PickupDisplayLogic: AnyObject {
    func getTripResult(trip: Trip)
    var delegate: PickupViewControllerDelegate? {get set}
}

final class PickupViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var interactor: PickupBusinessLogic?
    var router: (PickupRoutingLogic & PickupDataPassing)?
    weak var delegate: PickupViewControllerDelegate?
    lazy var contentView: PickupViewLogic = PickupView()
    
    // MARK: - Private Properties
    
    private let mapView = MKMapView()
    private var trip: Trip?
    
    
    //
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getTrip()
    }
    
    // MARK: - Requests
    
    func acceptTrip() {
        guard let trip = trip else {return}
        self.interactor?.acceptTrip(trip: trip, completion: { (error, ref) in
            self.dismiss(animated: true) {
                self.delegate?.didAccepted(trip: trip)
            }
        })
    }
    
    func getTrip() {
        self.interactor?.getTrip()
    }
    
    //
    
    // MARK: - Private Methods
    
    private func configure() {
        contentView.cancelButton(target: self, selector: #selector(handleCancel))
        contentView.acceptTripButton(target: self, selector: #selector(handleAccept))
    }
    
    
    // MARK: - UI Actions
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAccept() {
        acceptTrip()
    }
    
    //
}

// MARK: - Display Logic

extension PickupViewController: PickupDisplayLogic {
    func getTripResult(trip: Trip) {
        self.trip = trip
    }
}
