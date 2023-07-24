//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Abdelrahman on 23/07/2023.
//

import UIKit
import FirebaseAuth

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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(password)
        scrollView.addSubview(logginButton)
        view.backgroundColor = .systemBackground
        title = "Log In"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        logginButton.addTarget(self, action: #selector(didTapLogIn), for: .touchUpInside)
        emailField.delegate = self
        password.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        let size = scrollView.width/1.5
        imageView.frame = CGRect(x: (scrollView.width-size)/2, y: 0, width: size, height: size)
        emailField.frame = CGRect(x: 20, y: Int(imageView.bottom) + 20, width: Int(scrollView.width) - 40, height: 52)
        password.frame = CGRect(x: 20, y: emailField.bottom + 20, width: scrollView.width - 40, height: 52)
        logginButton.frame = CGRect(x: 50, y: Int(password.bottom) + 40, width: Int(scrollView.width) - 100, height: 52)
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
