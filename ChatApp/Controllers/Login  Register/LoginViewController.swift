//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Abdelrahman on 23/07/2023.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let loginLabel:UILabel = {
        let label = UILabel()
        label.text = "LOGIN"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let emailLabel:UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let passwordLabel:UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    
    
    private let emailField:UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "Enter Your Email"
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.layer.cornerRadius = 12
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailField.leftViewMode = .always
        emailField.backgroundColor = .systemBackground
        return emailField
    }()
    
    private let password:UITextField = {
        let password = UITextField()
        password.placeholder = "Enter Your Password"
        password.autocapitalizationType = .none
        password.autocorrectionType = .no
        password.returnKeyType = .done
        password.layer.cornerRadius = 12
        password.layer.borderWidth = 1
        password.layer.borderColor = UIColor.lightGray.cgColor
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        password.leftViewMode = .always
        password.backgroundColor = .systemBackground
        password.isSecureTextEntry = true
        return password
    }()
    
    private let logginButton:UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        return button
    }()
    
    private let fbLoggingButton:FBLoginButton = {
        let button = FBLoginButton()
        button.backgroundColor = .link
        
        button.permissions = ["email","public_profile"]
        
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        /*button.clipsToBounds = true
         button.layer.masksToBounds = true
         button.layer.borderWidth = 2*/
        //imageView.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(loginLabel)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(passwordLabel)
        scrollView.addSubview(emailField)
        scrollView.addSubview(password)
        scrollView.addSubview(logginButton)
        scrollView.addSubview(fbLoggingButton)
        view.backgroundColor = .systemBackground
        title = "Log In"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        logginButton.addTarget(self, action: #selector(didTapLogIn), for: .touchUpInside)
        emailField.delegate = self
        password.delegate = self
        
        fbLoggingButton.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        let size = scrollView.width/1.5
        imageView.frame = CGRect(x: (scrollView.width-size)/2, y: 0, width: size, height: size)
        //loginLabel.frame = CGRect(x: 20, y: imageView.bottom + 10, width: 100, height: 20)
        emailLabel.frame = CGRect(x: 20, y: imageView.bottom + 1, width: 50, height: 20)
        emailField.frame = CGRect(x: 20, y: Int(emailLabel.bottom) + 10, width: Int(scrollView.width) - 40, height: 50)
        passwordLabel.frame = CGRect(x: 20, y: emailField.bottom + 15, width: 100, height: 20)
        password.frame = CGRect(x: 20, y: passwordLabel.bottom + 10, width: scrollView.width - 40, height: 50)
        logginButton.frame = CGRect(x: 20, y: Int(password.bottom) + 30, width: Int(scrollView.width) - 40, height: 45)
        fbLoggingButton.frame = CGRect(x: 20, y: logginButton.bottom + 20, width: scrollView.width - 40, height: 45)
        //fbLoggingButton.layer.cornerRadius = fbLoggingButton.width/2
        //fbLoggingButton.backgroundColor = .red
        //fbLoggingButton.center = scrollView.center
        //fbLoggingButton.frame.origin.y = logginButton.bottom+40
    }
    
    
    
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapLogIn(){
        emailField.resignFirstResponder()
        password.resignFirstResponder()
        guard let email = emailField.text, let password = password.text, !email.isEmpty, !password.isEmpty, password.count >= 6,email.contains("@") else {
            alertUserLogInError(message: "Please enter correct data")
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else {return}
            guard let _ = authResult, error == nil else {
                self.alertUserLogInError(message: "Wrong Email or Password, Please try again.")
                return
            }
            self.navigationController?.dismiss(animated: true)
        }
        
        
    }
    
    func alertUserLogInError(message:String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        present(alert,animated: true)
    }
    
}


extension LoginViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            password.becomeFirstResponder()
        }else if textField == password {
            didTapLogIn()
        }
        
        return true
    }
}


extension LoginViewController:LoginButtonDelegate{
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
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
            //print("\(result)")
            
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
            
            DatabaseManager.shared.ifUserEmailExists(with: email) { exist in
                print(exist)
                if exist {
                    DatabaseManager.shared.insertUser(with: chatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                }
            }
            
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                guard error == nil else {
                    print("Credential failed")
                    return
                }
                self?.navigationController?.dismiss(animated: true)
            }
        }
        
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        // no operation
    }
    
    
}
