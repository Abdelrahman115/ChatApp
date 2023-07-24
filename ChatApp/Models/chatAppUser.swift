//
//  File.swift
//  ChatApp
//
//  Created by Abdelrahman on 24/07/2023.
//

import Foundation


struct chatAppUser{
    let firstName:String
    let lastName:String
    let emailAddress:String
    //let profilePictureURL:String
    
    var safeEmail:String{
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        return safeEmail
    }
}
