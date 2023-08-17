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
    
    static func safeEmail(email:String) -> String{
            var safeEmail = email.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
            return safeEmail
    }
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
            self.database.child("users").observeSingleEvent(of: .value) { snapShot in
                if var usersCollection = snapShot.value as? [[String:String]]{
                    //Append to users dictionary
                    let newElement =
                        ["name":user.firstName + " " + user.lastName,
                         "email":user.safeEmail]
                    usersCollection.append(newElement)
                    self.database.child("users").setValue(usersCollection) { error, _ in
                        guard error == nil else {completion(false); return}
                        completion(true)
                    }
                    
                }else{
                    //create that array
                    let newCollection:[[String:String]] = [
                        ["name":user.firstName + " " + user.lastName,
                         "email":user.safeEmail]
                    ]
                    
                    self.database.child("users").setValue(newCollection) { error, _ in
                        guard error == nil else {completion(false); return}
                        completion(true)
                    }
                }
                    
            }
            
        }
    }
    
    
    public func getAllUsers(completion: @escaping (Result<[[String:String]],Error>) -> Void){
        database.child("users").observeSingleEvent(of: .value) { snapShot  in
            guard let value = snapShot.value as? [[String:String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
    
    public enum DatabaseError:Error{
        case failedToFetch
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
