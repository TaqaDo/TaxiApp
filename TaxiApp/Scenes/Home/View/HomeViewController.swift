//
//  HomeViewController.swift
//  TaxiApp
//
//  Created by talgar osmonov on 2/4/21.
//

import UIKit
import FirebaseAuth
import MapKit
import SnapKit

private enum ActionButtonConfiguration {
    case showMenu
    case dismissActionMenu
    
    init() {
        self = .showMenu
    }
}

protocol HomeDisplayLogic: AnyObject {
    func fetchUserDataResult(user: User)
    func fetchDriversResult(driver: User)
    func observeTripResult(trip: Trip)
    func observeCurrentTripResult(trip: Trip)
}

private let annotationIdentifier = "DriverAnno"

final class HomeViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var interactor: HomeBusinessLogic?
    var router: (HomeRoutingLogic & HomeDataPassing)?
    
    lazy var inputActivationView: InputActivationViewLogic = InputActivationView()
    lazy var locationIntupView: LocationInputViewLogic = LocationInputView()
    lazy var rideActionView: RideActionViewLogic = RideActionView()
    let indicator = UIActivityIndicatorView()
    
    // MARK: - Private Properties
    
    private let locationManager = LocationHandler.shared.locationManager
    private lazy var mapView = MKMapView()
    private lazy var tableView = UITableView()
    private var actionButtonConfig = ActionButtonConfiguration()
    private var searchResults = [MKPlacemark]()
    private var route: MKRoute?
    private var selectedPlacemark: MKPlacemark?
    private var user: User?
    private var trip: Trip?
    
    // MARK: - Views
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp"), for: .normal)
        button.addTarget(self, action: #selector(handleActionButton), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    //
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chekForLoggingIn()
        enableLocationServices()
        configure()
        fetchUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav()
    }
    
    // MARK: - Requests
    
    private func cancelTrip() {
        self.interactor?.cancelTrip(completion: { (error, ref) in
            if let error = error {
                print("ERROR CANCEL")
                return
            }
            
            self.rideActionView.removeFromSuperview()
            self.removeAnnotaiontsAndOverlays()
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            
            UIView.animate(withDuration: 0.2) {
                self.inputActivationView.alpha = 1
                self.actionButtonType(config: .showMenu)
            }
        })
    }
    
    private func fetchDriverData(uid: String, completion: @escaping(_ user: User) -> Void) {
        self.interactor?.fetchPersoneData(uid: uid, completion: completion)
    }
    
    private func observeCurrentTrip() {
        self.interactor?.observeCurrentTrip()
    }
    
    private func obsevreTrips() {
        self.interactor?.observeTrips()
    }
    
    private func uploadTrip() {
        guard let pickupCoordinates = locationManager?.location?.coordinate else {return}
        guard let destinationCoordinates = selectedPlacemark?.coordinate else {return}
        self.interactor?.uploadTrip(pickupCoordinates: pickupCoordinates, destinationCoordinates: destinationCoordinates, completion: { (error, ref) in
            if error != nil {
                print("Error Upload a trip")
                return
            }
            self.indicator.startAnimating()
            self.rideActionView.removeFromSuperview()
        })
    }
    
    private func fetchDrivers() {
        guard let location = locationManager?.location else {return}
        self.interactor?.fetchDrivers(location: location)
    }
    
    private func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        self.interactor?.fetchUserData(uid: uid)
    }
    
    private func chekForLoggingIn() {
        guard let isLoggedIn = self.interactor?.isLogedin() else {return}
        
        if isLoggedIn {
            return
        } else {
            self.router?.navigateToLogin()
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            self.router?.navigateToLogin()
        } catch {
            print("Error signing out")
        }
    }
    
    //
    
    // MARK: - Private Methods
    
    func configure() {
        configureMap()
        configureActionButton()
        view.addSubview(indicator)
        indicator.style = .large
        indicator.center = view.center
    }
    
    //
    
    private func setCustomRegion(withCoordinates coordinates: CLLocationCoordinate2D) {
        let region = CLCircularRegion(center: coordinates, radius: 25, identifier: "pickup")
        locationManager?.startMonitoring(for: region)
    }
    
    private func removeAnnotaiontsAndOverlays() {
        mapView.annotations.forEach { (anno) in
            if let annotation = anno as? MKPointAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
        
        if mapView.overlays.count > 0 {
            mapView.removeOverlay(mapView.overlays[0])
        }
    }
    
    fileprivate func actionButtonType(config: ActionButtonConfiguration) {
        switch config {
        case .showMenu:
            self.actionButton.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
            self.actionButtonConfig = .showMenu
        case .dismissActionMenu:
            actionButton.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
            actionButtonConfig = .dismissActionMenu
        }
    }
    
    private func configureRideActionView() {
        self.view.addSubview(rideActionView)
        rideActionView.alpha = 0
        rideActionView.getActionButton(target: self, selector: #selector(uploadTripButton))
        rideActionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
    }
    
    private func configureActionButton() {
        self.view.addSubview(actionButton)
        actionButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeArea.top).inset(16)
            make.left.equalToSuperview().inset(18)
            make.size.equalTo(30)
        }
    }
    
    private func configureNav() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    private func configureMap() {
        self.view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
    }
    
    private func configureInputActivationView() {
        self.view.addSubview(inputActivationView)
        inputActivationView.presentLocationInputView(target: self, selector: #selector(handleLocationInput))
        inputActivationView.alpha = 0
        inputActivationView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view.snp.width).inset(22)
            make.height.equalTo(50)
            make.top.equalTo(self.view.safeArea.top).inset(62)
        }
        UIView.animate(withDuration: 0.3) {
            self.inputActivationView.alpha = 1
        }
    }
    
    private func configureLocationInputView() {
        locationIntupView.delegate = self
        self.view.addSubview(locationIntupView)
        locationIntupView.backButton(target: self, selector: #selector(handleBackFromLocation))
        locationIntupView.alpha = 0
        locationIntupView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.locationIntupView.alpha = 1
            self.configureTableView()
            self.tableView.alpha = 1
        }
        
    }
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(LocationInputCell.self, forCellReuseIdentifier: LocationInputCell.reuseIdentifier)
        self.tableView.rowHeight = 60
        self.tableView.alpha = 0
        
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(locationIntupView.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func dissmisLocationInputView(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.4, animations: {
            self.locationIntupView.removeFromSuperview()
            self.tableView.removeFromSuperview()
        }, completion: completion)
    }
    
    // MARK: - UI Actions
    
    @objc func uploadTripButton() {
        switch rideActionView.getActions() {
        
        case .requestRide:
            uploadTrip()
        case .cancel:
            cancelTrip()
        case .getDirections:
            print("getDIRECTIONS")
        case .pickup:
            print("PICKUP")
        case .dropOff:
            print("DROPOFF")
        }
    }
    
    @objc func handleActionButton() {
        switch actionButtonConfig {
        
        case .showMenu:
            print("YEYEYEYEYEYE")
        case .dismissActionMenu:
            
            self.rideActionView.removeFromSuperview()
            removeAnnotaiontsAndOverlays()
            mapView.showAnnotations(mapView.annotations, animated: true)
            
            UIView.animate(withDuration: 0.2) {
                self.inputActivationView.alpha = 1
                self.actionButtonType(config: .showMenu)
            }
        }
    }
    
    @objc func handleBackFromLocation() {
        dissmisLocationInputView { (_) in
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
            }
        }
    }
    
    @objc func handleLocationInput() {
        inputActivationView.alpha = 0
        configureLocationInputView()
    }
    
    //
}

// MARK: - Display Logic

extension HomeViewController: HomeDisplayLogic {
    
    func observeCurrentTripResult(trip: Trip) {
        
        guard let state = trip.state else {return}
        
        switch state {
        
        case .requested:
            break
        case .isAccepted:
            
            self.indicator.stopAnimating()
            self.removeAnnotaiontsAndOverlays()
            self.mapView.annotations.forEach { (anno) in
                
            }
            
            guard let driverUid = trip.driverUid else {return}
            fetchDriverData(uid: driverUid) { (driver) in
                self.rideActionView.user = driver
                self.configureRideActionView()
                self.rideActionView.alpha = 1
                self.rideActionView.configureRideActionView(withConfig: .tripAccepted)
            }
            
        case .driverArrived:
            self.rideActionView.configureRideActionView(withConfig: .driverArrived)
        case .inProgress:
            break
        case .isCompleted:
            break
        }
    }
    
    func observeTripResult(trip: Trip) {
        self.router?.navigateToPickup(trip: trip, delegate: self)
    }
    
    func fetchUserDataResult(user: User) {
        self.user = user
        if user.accountType == .passenger {
            configureInputActivationView()
            locationIntupView.setupData(user: user)
            observeCurrentTrip()
            fetchDrivers()
        } else {
            obsevreTrips()
        }
    }
    
    func fetchDriversResult(driver: User) {
        guard let coordinate = driver.location?.coordinate else {return}
        let anotation = DriverAnotation.init(uid: driver.uid, coordinate: coordinate)
        
        var driverIsVisible: Bool {
            return self.mapView.annotations.contains { (anotation) -> Bool in
                guard let driverAnno = anotation as? DriverAnotation else {return false}
                if driverAnno.uid == driver.uid {
                    driverAnno.updateAnnotationPosition(coordinate: coordinate)
                    return true
                }
                return false
            }
            
        }
        
        if !driverIsVisible {
            self.mapView.addAnnotation(anotation)
        }
    }
}

// MARK: - PickupViewDelegate

extension HomeViewController: PickupViewControllerDelegate {
    func didAccepted(trip: Trip) {
        self.trip = trip
        
        let anno = MKPointAnnotation()
        anno.coordinate = trip.pickupCoordiantes
        mapView.addAnnotation(anno)
        
        setCustomRegion(withCoordinates: trip.pickupCoordiantes)
        
        let placemark = MKPlacemark(coordinate: trip.pickupCoordiantes)
        let mapItem = MKMapItem(placemark: placemark)
        generatePolyline(toDestination: mapItem)
        mapView.zoomToFit(annotations: mapView.annotations)
        
        self.interactor?.observeTripCanceled(trip: trip, completion: {
            
            self.rideActionView.removeFromSuperview()
            self.removeAnnotaiontsAndOverlays()
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        
        })
        
        UIView.animate(withDuration: 0.5) {
            self.fetchDriverData(uid: trip.passengerUid) { (user) in
                self.rideActionView.user = user
                self.configureRideActionView()
                self.rideActionView.configureRideActionView(withConfig: .tripAccepted)
                self.rideActionView.alpha = 1
            }
        }
        
    }
}

// MARK: - TableView\Del\DS

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Test"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationInputCell.reuseIdentifier,
                                                       for: indexPath) as? LocationInputCell else {return UITableViewCell()}
        
        if indexPath.section == 1 {
            cell.setupData(placeMark: searchResults[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedPlacemark = searchResults[indexPath.row]
        
        self.rideActionView.setupData(destination: selectedPlacemark)
        
        let destination = MKMapItem(placemark: selectedPlacemark!)
        generatePolyline(toDestination: destination)
        actionButtonType(config: .dismissActionMenu)
        
        dissmisLocationInputView { (_) in
            let annotation = MKPointAnnotation()
            annotation.coordinate = self.selectedPlacemark!.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
            
            let annotations = self.mapView.annotations.filter({!$0.isKind(of: DriverAnotation.self)})
            
            self.mapView.zoomToFit(annotations: annotations)
            
            UIView.animate(withDuration: 0.5) {
                self.configureRideActionView()
                self.rideActionView.configureRideActionView(withConfig: .requestRide)
                self.rideActionView.alpha = 1
            }
        }
        
        
    }
    
    
}

// MARK: - LocationInputViewDelegate

extension HomeViewController: LocationInputViewDelegate {
    
    func executeSearch(query: String) {
        searchBy(naturalLanguageQuery: query) { (results) in
            self.searchResults = results
            self.tableView.reloadData()
        }
    }
}

// MARK: - Map Helper Functions

private extension HomeViewController {
    
    func searchBy(naturalLanguageQuery: String, completion: @escaping([MKPlacemark]) -> Void) {
        var results = [MKPlacemark]()
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {return}
            response.mapItems.forEach { (item) in
                results.append(item.placemark)
            }
            
            completion(results)
        }
    }
    
    func generatePolyline(toDestination destination: MKMapItem) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile
        let directionRequest = MKDirections(request: request)
        directionRequest.calculate { (response, error) in
            guard let response = response else {return}
            self.route = response.routes[0]
            guard let polyline = self.route?.polyline else {return}
            self.mapView.addOverlay(polyline)
        }
    }
}

// MARK: - MKMapViewDelegate

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let user = self.user else {return}
        guard user.accountType == .driver else {return}
        guard let location = userLocation.location else {return}
        self.interactor?.updateDriverLocation(location: location)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let anotation = annotation as? DriverAnotation {
            let view = MKAnnotationView(annotation: anotation, reuseIdentifier: annotationIdentifier)
            view.image = #imageLiteral(resourceName: "chevron-sign-to-right")
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let route = self.route {
            let polyline = route.polyline
            let lineRender = MKPolylineRenderer(overlay: polyline)
            lineRender.strokeColor = .systemPink
            lineRender.lineWidth = 3
            return lineRender
        }
        
        return MKOverlayRenderer()
    }
}

// MARK: - shouldPresenstLoadingView

extension HomeViewController {
    func shouldPresenstLoadingView(_ present: Bool, message: String? = nil) {
        //        let indicator = UIActivityIndicatorView()
        //        let label = UILabel()
        //
        //        if present {
        //
        //            indicator.style = .large
        //            indicator.center = view.center
        //
        //
        //
        //            label.text = message
        //            label.font = UIFont.systemFont(ofSize: 26)
        //            label.textColor = .red
        //
        //            self.view.addSubview(indicator)
        //            self.view.addSubview(label)
        //
        //
        //            indicator.startAnimating()
        //        } else {
        //            indicator.removeFromSuperview()
        //            label.removeFromSuperview()
        //            indicator.stopAnimating()
        //        }
    }
}

// MARK: - LocationServices

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("TRSTSTSTSTSTSTTSTS \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.rideActionView.configureRideActionView(withConfig: .pickupPassenger)
        guard let trip = trip else {return}
        self.interactor?.updateTripState(trip: trip, state: .driverArrived)
    }
    
    func enableLocationServices() {
        locationManager?.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        
        case .notDetermined:
            print("DEBUG: Not determined..")
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("DEBUG: Auth always..")
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: Auth when in use..")
            locationManager?.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
    
}
