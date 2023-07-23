//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Abdelrahman on 23/07/2023.
//

import UIKit

class RegisterViewController: UIViewController {
    private let scrollView:UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let imageView:UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let firstNameField:UITextField = {
       let emailField = UITextField()
        emailField.placeholder = "  Enter Your First Name"
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
    
    private let lastNameField:UITextField = {
       let emailField = UITextField()
        emailField.placeholder = "  Enter Your Last Name"
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
    
    private let emailField:UITextField = {
       let emailField = UITextField()
        emailField.placeholder = "  Enter Your Email"
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
        password.placeholder = "  Enter Your Password"
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
    
    private let passwordConfirm:UITextField = {
        let password = UITextField()
        password.placeholder = "  Enter Your Password Again"
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
    
    private let registerButton:UIButton = {
       let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
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
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(password)
        scrollView.addSubview(passwordConfirm)
        scrollView.addSubview(registerButton)
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        let geasture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        //geasture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(geasture)
        
        view.backgroundColor = .systemBackground
        title = "Register"
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        emailField.delegate = self
        password.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        let size = scrollView.width/1.5
        imageView.frame = CGRect(x: (scrollView.width-size)/2, y: 0, width: size, height: size)
        firstNameField.frame = CGRect(x: 20, y: Int(imageView.bottom) + 10, width: Int(scrollView.width) - 40, height: 52)
        lastNameField.frame = CGRect(x: 20, y: Int(firstNameField.bottom) + 10, width: Int(scrollView.width) - 40, height: 52)
        emailField.frame = CGRect(x: 20, y: Int(lastNameField.bottom) + 10, width: Int(scrollView.width) - 40, height: 52)
        password.frame = CGRect(x: 20, y: emailField.bottom + 10, width: scrollView.width - 40, height: 52)
        passwordConfirm.frame = CGRect(x: 20, y: password.bottom + 10, width: scrollView.width - 40, height: 52)

        registerButton.frame = CGRect(x: 50, y: Int(passwordConfirm.bottom) + 20, width: Int(scrollView.width) - 100, height: 52)
    }
    
    
    
    
 
    
    @objc private func didTapRegister(){
        emailField.resignFirstResponder()
        password.resignFirstResponder()
        guard let firstName = firstNameField.text,let lastName = lastNameField.text,let email = emailField.text, let password = password.text,let passwordConfirm = passwordConfirm.text,!firstName.isEmpty,!lastName.isEmpty ,!email.isEmpty, !password.isEmpty, password.count >= 6,!passwordConfirm.isEmpty,passwordConfirm.count >= 6,email.contains("@"),password == passwordConfirm else {
            alertUserLogInError()
            return
        }
    }
    
    @objc private func didTapChangeProfilePic(){
        print("ssdawd")
    }
    
    func alertUserLogInError(){
        let alert = UIAlertController(title: "Error", message: "Please fill all required data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        present(alert,animated: true)
    }
}


extension RegisterViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            password.becomeFirstResponder()
        }else if textField == password {
            didTapRegister()
        }
        
        return true
    }
}
