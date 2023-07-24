//
//  DatabaseManager.swift
//  ChatApp
//
//  Created by Abdelrahman on 24/07/2023.
//

import Foundation
import FirebaseDatabase


final class DatabaseManager{
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}
// MARK: - Account management
extension DatabaseManager{
    
    /*public func ifUserEmailExists(with email:String,completion: @escaping((Bool)->Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapShot in
            print(safeEmail)
            print(snapShot.value as? String)
            guard snapShot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }*/
    
    
    
    ///inserts new user to database
    public func insertUser(with user:chatAppUser){
        database.child(user.safeEmail).setValue(["firstName":user.firstName,
                                                   "lastName":user.lastName
                                                  ])
    }
}
