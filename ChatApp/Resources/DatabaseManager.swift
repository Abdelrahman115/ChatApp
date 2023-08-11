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
    
    //inserts new user to database
    public func insertUser(with user:chatAppUser, completion:@escaping (Bool) -> Void){
        database.child(user.safeEmail).setValue(["firstName":user.firstName,"lastName":user.lastName]) { error, _ in
            guard error == nil else {
                print("failed to write to data base")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
    /*public func ifUserEmailExists(with email:String,completion: @escaping((Bool)->Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        /*database.child(safeEmail).observeSingleEvent(of: .value) { snapShot in
            print(safeEmail)
            print(snapShot.value)
            guard snapShot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }*/
        let databaseReff = Database.database().reference().child("users")

                            databaseReff.queryOrdered(byChild: "email").queryEqual(toValue: safeEmail).observe(.value, with: { snapshot in
                                if snapshot.exists(){

                                   //User email exist
                                    print(snapshot)
                                    print(snapshot.exists())
                                }
                                else{
                                    //email does not [email id available]
                                    print(snapshot)
                                }

                            })
    }*/
}
