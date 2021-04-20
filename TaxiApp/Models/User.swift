//
//  UserInfo.swift
//  TaxiApp
//
//  Created by talgar osmonov on 4/4/21.
//

import Foundation
import CoreLocation

enum AccountType: Int {
    case passenger
    case driver
}

struct User {
    var fullname: String?
    var userEmail: String?
    var accountType: AccountType!
    var location: CLLocation?
    let uid: String
    
    init(uid: String, dictionary: [String : Any]) {
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.userEmail = dictionary["email"] as? String ?? ""
        self.uid = uid
        
        if let index = dictionary["accountType"] as? Int {
            self.accountType = AccountType(rawValue: index)!
        }
    }
}
