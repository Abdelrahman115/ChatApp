//
//  NewConversationViewModel.swift
//  ChatApp
//
//  Created by Abdelrahman on 17/08/2023.
//

import Foundation
import FirebaseAuth
import JGProgressHUD
import FBSDKLoginKit
import GoogleSignIn

class NewConversationViewModel {
    
    var bindUsersToNewConversationView:(() -> ()) = {}
    var users:[[String:String]]?{
        didSet{
            bindUsersToNewConversationView()
        }
    }
    
    
    
    func fetchUsers(){
        DatabaseManager.shared.getAllUsers { [weak self] result in
            guard let self  = self  else {return}
            switch result{
            case.success(let users):
                self.users = users
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
