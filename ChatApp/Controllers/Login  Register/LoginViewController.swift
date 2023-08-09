//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Abdelrahman on 23/07/2023.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import Firebase

class LoginViewController: UIViewController{
    
    private var viewModel: LoginViewModel!
    
    
    // MARK: - UI elements
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
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.gray.cgColor
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.layer.cornerRadius = 5
        emailField.returnKeyType = .continue
        emailField.leftViewMode = .always
        return emailField
    }()
    
    private let password:UITextField = {
        let password = UITextField()
        password.placeholder = "Password"
        password.borderStyle = .roundedRect
        password.isSecureTextEntry = true
        password.autocapitalizationType = .none
        password.autocorrectionType = .no
        password.returnKeyType = .done
        password.layer.cornerRadius = 5
        password.layer.borderWidth = 1
        password.layer.borderColor = UIColor.gray.cgColor
        return password
    }()
    
    private let logginButton:UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        return button
    }()
    
    private let notRegisteredLabel:UILabel = {
        let label = UILabel()
        label.text = "Not registered yet? "
        return label
    }()
    
    
    private let signUpButton:UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    let leftSeparator:UIView = {
        let leftSeparator = UIView()
        leftSeparator.backgroundColor = UIColor.lightGray
        leftSeparator.translatesAutoresizingMaskIntoConstraints = false
        return leftSeparator
    }()
    
    let rightSeperator:UIView = {
        let rightSeperator = UIView()
        rightSeperator.backgroundColor = UIColor.lightGray
        rightSeperator.translatesAutoresizingMaskIntoConstraints = false
        return rightSeperator
    }()
       
    let orLabel:UILabel = {
       let orLabel = UILabel()
        orLabel.text = "or"
        return orLabel
    }()
       
    
    private let fbLoggingButton:FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email","public_profile"]
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let googleLogginButton:UIButton = {
        let button = UIButton()
        button.setTitle("Continue with Google", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setImage(UIImage(named: "google"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    // MARK: - Setup UI
    private func setupUI(){
        //Add Subviews
        addSubviews()
        
        //View Properties
        view.backgroundColor = .systemBackground
        title = "Log In"
        
        //Add Targets to buttons
       addButtonsTargets()
        
        //Configure Delegates
        emailField.delegate = self
        password.delegate = self
        fbLoggingButton.delegate = self
        
        //Add frames of ui elements
        addFrames()
        
    }
    
    private func addSubviews(){
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(notRegisteredLabel)
        scrollView.addSubview(emailField)
        scrollView.addSubview(password)
        scrollView.addSubview(logginButton)
        scrollView.addSubview(signUpButton)
        scrollView.addSubview(leftSeparator)
        scrollView.addSubview(rightSeperator)
        scrollView.addSubview(orLabel)
        scrollView.addSubview(fbLoggingButton)
        scrollView.addSubview(googleLogginButton)
    }
    
    private func addFrames(){
        scrollView.frame = view.bounds
        let size = scrollView.width/1.5
        imageView.frame = CGRect(x: (scrollView.width-size)/2, y: 0, width: size, height: size)
        emailField.frame = CGRect(x: 20, y: Int(imageView.bottom), width: Int(scrollView.width) - 40, height: 50)
        password.frame = CGRect(x: 20, y: emailField.bottom + 10, width: scrollView.width - 40, height: 50)
        logginButton.frame = CGRect(x: 20, y: Int(password.bottom) + 30, width: Int(scrollView.width) - 40, height: 45)
        notRegisteredLabel.frame = CGRect(x: 50, y: Int(logginButton.bottom) + 10, width: 180, height: 50)
        signUpButton.frame = CGRect(x: notRegisteredLabel.right, y: logginButton.bottom + 10, width: 100, height: 50)
        leftSeparator.frame = CGRect(x: 20, y: signUpButton.bottom + 20, width: scrollView.width / 2 - 40, height: 2)
        orLabel.frame = CGRect(x: scrollView.width / 2 - 10, y: signUpButton.bottom+10, width: 20, height: 20)
        rightSeperator.frame = CGRect(x: orLabel.right + 5, y: signUpButton.bottom + 20, width: scrollView.width / 2 - 50, height: 2)
        fbLoggingButton.frame = CGRect(x: 20, y: orLabel.bottom + 20, width: scrollView.width - 40, height: 45)
        googleLogginButton.frame = CGRect(x: 20, y: fbLoggingButton.bottom + 20, width: scrollView.width - 40, height: 45)
        googleLogginButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 2, bottom: 10, right: googleLogginButton.width - 25)
        let scrollViewHeight = imageView.height + emailField.height + password.height + logginButton.height + signUpButton.height + orLabel.height + fbLoggingButton.height + googleLogginButton.height + 100
        scrollView.contentSize = CGSize(width: view.width, height: scrollViewHeight)
    }
    
    private func addButtonsTargets(){
        logginButton.addTarget(self, action: #selector(didTapLogIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        googleLogginButton.addTarget(self, action: #selector(didTapGooleLogin), for: .touchUpInside)
    }
    
   
    // MARK: - Setup ViewModel
    
    private func setupViewModel() {
            viewModel = LoginViewModel()
            viewModel.delegate = self
        }
    
    // MARK: - Target functions
    @objc private func didTapLogIn(){
        emailField.resignFirstResponder()
        password.resignFirstResponder()
        guard let email = emailField.text, let password = password.text, !email.isEmpty, !password.isEmpty, password.count >= 6,email.contains("@") else {
            alertUserLogInError(message: "Please enter correct data")
            return
        }
        viewModel.loginUser(email: email, password: password)
    }
    
    
    @objc private func didTapSignUp(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc private func didTapGooleLogin(){
        guard let email = emailField.text, let password = password.text else {
            return
        }
        viewModel.logInUsingGoogle(email: email, password: password, Presenting: self)
    }
    
    // MARK: - Alert function
    func alertUserLogInError(message:String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        present(alert,animated: true)
    }
}



// MARK: - TextField Delegate
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


// MARK: - Facebook Login Delegate
extension LoginViewController:LoginButtonDelegate{
   
    
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
        viewModel.loginUsingFacebook(loginButton, didCompleteWith: result, error: error)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        
    }
}


// MARK: - viewModel Delegate
extension LoginViewController: LoginViewModelDelegate {
    func loginSuccess() {
        navigationController?.dismiss(animated: true)
    }

    func loginFailure(error: Error) {
        let errorMessage = "An error occurred: \(error.localizedDescription)"
        alertUserLogInError(message: errorMessage)
    }
}






