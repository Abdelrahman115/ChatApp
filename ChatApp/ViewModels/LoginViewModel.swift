//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Abdelrahman on 09/08/2023.
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import Firebase
import FBSDKLoginKit


protocol LoginViewModelDelegate: AnyObject {
    func loginSuccess()
    func loginFailure(error: Error)
}

class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?

    func loginUser(email: String, password: String) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.loginFailure(error: error)
            } else {
                self.delegate?.loginSuccess()
            }
        }
    }
    
    
    func logInUsingGoogle(email: String, password: String, Presenting:UIViewController){
    
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: Presenting) { [unowned self] result, error in
            
        guard error == nil else { return }
        guard let user = result?.user,
              let idToken = user.idToken?.tokenString
            else
            { return }
            
        let firstName = user.profile?.givenName
        let lastName = user.profile?.familyName
        let email = user.profile?.email
            
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken:user.accessToken.tokenString
        )

              
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            guard let self = self else {return}
                if let error = error {
                      self.delegate?.loginFailure(error: error)
                  } else {
                      DatabaseManager.shared.insertUser(with: chatAppUser(firstName: firstName ?? "", lastName: lastName ?? "", emailAddress: email ?? ""))
                      self.delegate?.loginSuccess()
                  }
              }
        }
    }
    
    
    func loginUsingFacebook(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?){
        
        guard let token = result?.token?.tokenString else {
            print("User failed to login with facebook")
            return
        }
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, name,id"], tokenString: token, version: nil, httpMethod: .get)
        
        facebookRequest.start { _, result, error in
            guard let result = result as? [String: Any], error == nil else{
                print("Failed to make facebook graph request")
                return
            }
            
            guard let userName = result["name"] as? String, let email = result["email"] as? String else{
                print("failed to get email")
                return
            }
            let nameComponents = userName.components(separatedBy: " ")
            guard nameComponents.count == 2 else{
                return
            }
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            
        
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    self?.delegate?.loginFailure(error: error)
                } else {
                    DatabaseManager.shared.insertUser(with: chatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                    self?.delegate?.loginSuccess()
                }
            }
        }
        
        
    }
    
}



