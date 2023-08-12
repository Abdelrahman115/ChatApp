//
//  RegisterViewModel.swift
//  ChatApp
//
//  Created by Abdelrahman on 09/08/2023.
//

import Foundation
import FirebaseAuth
import JGProgressHUD


protocol RegisterViewModelDelegate: AnyObject {
    func registrationSuccess()
    func registrationFailure(error: Error)
}

class RegisterViewModel {
    weak var delegate: RegisterViewModelDelegate?

    func registerUser(firstName: String, lastName: String, email: String, password: String, spinner:JGProgressHUD,imageView:UIImageView) {
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            spinner.dismiss()
            if let error = error {
                self.delegate?.registrationFailure(error: error)
            } else {
                let chatUser = chatAppUser(firstName: firstName, lastName: lastName, emailAddress: email)
                DatabaseManager.shared.insertUser(with: chatUser) { success in
                    if success{
                        //Upload Image
                        guard let image =  imageView.image, let data = image.pngData() else {return}
                        let fileName = chatUser.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName) { result in
                            switch result{
                            case.success(let downloadURL):
                                UserDefaults.standard.setValue(downloadURL, forKey: "profile_Picture_url")
                                //print(downloadURL)
                            case.failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                    
                }
                
                self.delegate?.registrationSuccess()
            }
        }
    }
    
    
    func alertUserLogInError(message:String,view:UIViewController){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        view.present(alert,animated: true)
    }
}


extension RegisterViewModel{
    
}
