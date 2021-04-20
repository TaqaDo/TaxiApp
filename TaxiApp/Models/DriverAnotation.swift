//
//  DriverAnotation.swift
//  TaxiApp
//
//  Created by talgar osmonov on 9/4/21.
//

import MapKit


class DriverAnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    let uid: String
    
    init(uid: String, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.uid = uid
    }
    
    func updateAnnotationPosition(coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration:  0.2) {
            self.coordinate = coordinate
        }
    }
}
