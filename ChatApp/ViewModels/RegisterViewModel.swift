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

    func registerUser(firstName: String, lastName: String, email: String, password: String, spinner:JGProgressHUD) {
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            spinner.dismiss()
            if let error = error {
                self.delegate?.registrationFailure(error: error)
            } else {
                self.delegate?.registrationSuccess()
            }
        }
    }
}
