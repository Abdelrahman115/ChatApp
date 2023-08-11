//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Abdelrahman on 23/07/2023.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewProperties()
    }
    
    
    private func tableViewProperties(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Sign Out"
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alertUserLogOut()
    }
    
    
    func alertUserLogOut(){
        let alert = UIAlertController(title: "Alert", message: "Do you really want to LogOut?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "yes", style: .destructive,handler: { [weak self] action in
            guard let self = self else {return}
            
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
                self.present(nav,animated: true)
                
            }catch{
                print("Failed to log out")
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        present(alert,animated: true)
    }
}
