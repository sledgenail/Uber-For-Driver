//
//  DBReference.swift
//  Uber App For Driver
//
//  Created by Emmanuel Erilibe on 1/27/17.
//  Copyright © 2017 Emmanuel Erilibe. All rights reserved.
//

import Foundation

import FirebaseDatabase

class DBProvider {
    private static let _instance = DBProvider()
    
    static var Instance: DBProvider {
        return _instance
    }
    
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var driversRef: FIRDatabaseReference {
        return dbRef.child(Constants.DRIVERS)
    }
    
    //Request Reference
    var requestRef: FIRDatabaseReference {
        return dbRef.child(Constants.UBER_REQUEST)
    }
    
    //Request Accepted
    var requestAcceptedRef: FIRDatabaseReference {
        return dbRef.child(Constants.UBER_ACCEPTED)
    }
    
    
    func saveUser(withID: String,  email: String, password: String) {
        
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password, Constants.isRider: false]
        
        driversRef.child(withID).child(Constants.DATA).setValue(data)
    }
    
}
