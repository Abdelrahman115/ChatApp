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
import JGProgressHUD


protocol LoginViewModelDelegate: AnyObject {
    func loginSuccess()
    func loginFailure(error: Error)
}

class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?

    func loginUser(email: String, password: String,spinner:JGProgressHUD) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            guard let self = self else { return }
            DispatchQueue.main.async {
                spinner.dismiss()
            }
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
            
            guard let firstName = user.profile?.givenName,
                  let lastName = user.profile?.familyName,
                  let email = user.profile?.email,
                  let hasImage = user.profile?.hasImage
            else {return}
        
        
            
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken:user.accessToken.tokenString
        )

              
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            guard let self = self else {return}
                if let error = error {
                      self.delegate?.loginFailure(error: error)
                  } else {
                      let chatUser = chatAppUser(firstName: firstName , lastName: lastName , emailAddress: email )
                      DatabaseManager.shared.insertUser(with: chatUser) { success in
                          if success{
                              //Upload Image
                              if hasImage{
                                  guard let url = user.profile?.imageURL(withDimension: 200) else {return}
                                  
                                  URLSession.shared.dataTask(with: url) { data, _, error in
                                      guard let data = data else {return}
                                      
                                      let fileName = chatUser.profilePictureFileName
                                      StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName) { result in
                                          switch result{
                                          case.success(let downloadURL):
                                              UserDefaults.standard.setValue(downloadURL, forKey: "profile_Picture_url")
                                          case.failure(let error):
                                              print(error.localizedDescription)
                                          }
                                      }
                                  }.resume()
                              }
                          }
                      }
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
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, first_name, last_name, picture.type(large)"], tokenString: token, version: nil, httpMethod: .get)
        
        facebookRequest.start { _, result, error in
            guard let result = result as? [String: Any], error == nil else{
                print("Failed to make facebook graph request")
                return
            }
            
            
            
            guard let firstName = result["first_name"] as? String,
                  let lastName = result["last_name"] as? String ,
                  let email = result["email"] as? String,
                  let picture = result["picture"] as? [String:Any],
                  let data = picture["data"] as? [String:Any],
                  let pictureURL = data["url"] as? String
            else{
                print("failed to get email")
                return
            }
            
            
            
            
            
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    self?.delegate?.loginFailure(error: error)
                } else {
                    let chatUser = chatAppUser(firstName: firstName , lastName: lastName , emailAddress: email )
                    DatabaseManager.shared.insertUser(with: chatUser) { success in
                        if success{
                            guard let url = URL(string: pictureURL) else {return}
                            
                            print("Downloading data from facebook image")
                            print(url)
                            
                            URLSession.shared.dataTask(with: url) { data, _, error in
                                guard let data = data else {
                                    print("Failed to get data from facebook")
                                    return
                                }
                                //Upload Image
                                
                                print("got data from facebook uploading")
                                
                                let fileName = chatUser.profilePictureFileName
                                StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName) { result in
                                    switch result{
                                    case.success(let downloadURL):
                                        UserDefaults.standard.setValue(downloadURL, forKey: "profile_Picture_url")
                                    case.failure(let error):
                                        print(error.localizedDescription)
                                    }
                                }
                            }.resume()
                            
                        }
                    }
                    self?.delegate?.loginSuccess()
                }
            }
        }
        
        
    }
    
}



