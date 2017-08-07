//
//  User.swift
//  CardCart
//
//  Created by Jay Patel on 7/11/17.
//  Copyright © 2017 JP Apps. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    
    
    
    // MARK: - Properties
    
    let uid: String
    
    // MARK: - Init
    
    init(uid: String) {
        self.uid = uid
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String else {
            return nil
        }
        self.uid = uid
    }

    
        
    private static var _current: User?
    
    
    static var current: User {
        
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        
        return currentUser
    }
    
    // MARK: - Class Methods
    
    
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        _current = user
        if writeToUserDefaults {
            let userData = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(userData, forKey: Constants.UserDefaults.currentUser)
        }
    }

}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
    }
    
}

