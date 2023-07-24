//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Abdelrahman on 23/07/2023.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    ///Properties
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
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        return imageView
    }()
    
    private let firstNameField:UITextField = {
       let emailField = UITextField()
        emailField.placeholder = "Enter Your First Name"
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
        emailField.placeholder = "Enter Your Last Name"
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
    
    private let passwordConfirm:UITextField = {
        let password = UITextField()
        password.placeholder = "Enter Your Password Again"
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
    /// End of property declaration
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        ///View properties
        view.backgroundColor = .systemBackground
        title = "Register"
        
        //Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(password)
        scrollView.addSubview(passwordConfirm)
        scrollView.addSubview(registerButton)
        
        ///change profile picture
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        let geasture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        imageView.addGestureRecognizer(geasture)
        
        ///Register Button
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        ///TextFields delegates
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        password.delegate = self
        passwordConfirm.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ///scroll view frame and size
        scrollView.frame = view.bounds
        //scrollView.contentSize = CGSize(width: view.width, height: 2200)
        
        ///subViews frame
        let size = scrollView.width/2
        imageView.frame = CGRect(x: (scrollView.width-size)/2, y: 0, width: size, height: size)
        imageView.layer.cornerRadius = size/2
        firstNameField.frame = CGRect(x: 20, y: Int(imageView.bottom) + 30, width: Int(scrollView.width) - 40, height: 52)
        lastNameField.frame = CGRect(x: 20, y: Int(firstNameField.bottom) + 10, width: Int(scrollView.width) - 40, height: 52)
        emailField.frame = CGRect(x: 20, y: Int(lastNameField.bottom) + 10, width: Int(scrollView.width) - 40, height: 52)
        password.frame = CGRect(x: 20, y: emailField.bottom + 10, width: scrollView.width - 40, height: 52)
        passwordConfirm.frame = CGRect(x: 20, y: password.bottom + 10, width: scrollView.width - 40, height: 52)
        registerButton.frame = CGRect(x: 50, y: Int(passwordConfirm.bottom) + 30, width: Int(scrollView.width) - 100, height: 52)
    }
    
    
    
    
 
    
    @objc private func didTapRegister(){
        emailField.resignFirstResponder()
        password.resignFirstResponder()
        guard let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              let email = emailField.text,
              let password = password.text,
              let passwordConfirm = passwordConfirm.text,
              !firstName.isEmpty,
              !lastName.isEmpty ,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6,
              !passwordConfirm.isEmpty,
              passwordConfirm.count >= 6,
              email.contains("@"),
              password == passwordConfirm else {
            alertUserLogInError(message: "Please fill all data")
            return
        }
 
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let _ = authResult,  error == nil else {
                self?.alertUserLogInError(message: "This email is already exists")
                return
            }
            DatabaseManager.shared.insertUser(with: chatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
            self?.navigationController?.dismiss(animated: true)
        }
    }
    
    ///register error alert
    func alertUserLogInError(message:String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        present(alert,animated: true)
    }
    
    
    ///Change profile pic
    @objc private func didTapChangeProfilePic(){
        presentPhotoActionSheet()
        
        
    }
}


extension RegisterViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField{
            lastNameField.becomeFirstResponder()
        }else if textField == lastNameField {
            emailField.becomeFirstResponder()
        }else if textField == emailField{
            password.becomeFirstResponder()
        }else if textField == password{
            passwordConfirm.becomeFirstResponder()
        }else if textField == passwordConfirm{
            didTapRegister()
        }
        return true
    }
    
    
    
}


extension RegisterViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Select an option.", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        actionSheet.addAction(UIAlertAction(title: "Take a Photo", style: .default,handler: {[weak self] _ in
            self?.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose from your library", style: .default,handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet,animated: true)
    }
    
    func presentCamera(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    func presentPhotoPicker(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            imageView.image = image
        }
        self.dismiss(animated: true)
    }
}
