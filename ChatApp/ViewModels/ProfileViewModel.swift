//
//  RegisterViewModel.swift
//  ChatApp
//
//  Created by Abdelrahman on 09/08/2023.
//

import Foundation
import FirebaseAuth
import JGProgressHUD
import FBSDKLoginKit
import GoogleSignIn




class ProfileViewModel {
    
    var bindImageURLtoProfileView:(() -> ()) = {}
    var imageURL:String?{
        didSet{
           bindImageURLtoProfileView()
        }
    }
    
    func fetchImageURL(path:String){
        StorageManager.shared.downloadURL(for: path) {[weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let url):
                self.imageURL = url
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func signOut(profileView:UIViewController){
        //Logout Facebook
        FBSDKLoginKit.LoginManager().logOut()
        
        //Google LogOut
        GIDSignIn.sharedInstance.signOut()
        
        
        do{
            try FirebaseAuth.Auth.auth().signOut()
            
            //self.navigationController?.popToRootViewController(animated: true)
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            profileView.present(nav,animated: true)
            
        }catch{
            print("Failed to log out")
        }
    }
    
    func alertUserLogOut(view:UIViewController){
        let alert = UIAlertController(title: "Alert", message: "Do you really want to LogOut?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "yes", style: .destructive,handler: { [weak self] action in
            guard let self = self else {return}
            self.signOut(profileView: view)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        view.present(alert,animated: true)
    }
    
}
