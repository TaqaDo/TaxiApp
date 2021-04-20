//
//  Constants.swift
//  TaxiApp
//
//  Created by talgar osmonov on 3/4/21.
//

import Foundation
import Firebase
import CoreLocation

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_DRIVER_LOCATIONS = DB_REF.child("driver-locations")
let REF_TRIPS = DB_REF.child("trips")
let currentUID = Auth.auth().currentUser?.uid
