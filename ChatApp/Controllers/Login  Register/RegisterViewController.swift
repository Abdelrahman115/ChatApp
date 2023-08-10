//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Abdelrahman on 23/07/2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    private var viewModel: RegisterViewModel!
    private let spinner = JGProgressHUD(style: .light)
    
    // MARK: - UI elements
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView:UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.circle")
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
        emailField.placeholder = "First Name"
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.layer.cornerRadius = 5
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailField.leftViewMode = .always
        emailField.backgroundColor = .systemBackground
        return emailField
    }()
    
    private let lastNameField:UITextField = {
       let emailField = UITextField()
        emailField.placeholder = "Last Name"
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.layer.cornerRadius = 5
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailField.leftViewMode = .always
        emailField.backgroundColor = .systemBackground
        return emailField
    }()
    
    private let emailField:UITextField = {
       let emailField = UITextField()
        emailField.placeholder = "Email"
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.layer.cornerRadius = 5
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailField.leftViewMode = .always
        emailField.backgroundColor = .systemBackground
        return emailField
    }()
    
    private let password:UITextField = {
        let password = UITextField()
        password.placeholder = "Password"
        password.autocapitalizationType = .none
        password.autocorrectionType = .no
        password.returnKeyType = .done
        password.layer.cornerRadius = 5
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
        password.placeholder = "Password Confirm"
        password.autocapitalizationType = .none
        password.autocorrectionType = .no
        password.returnKeyType = .done
        password.layer.cornerRadius = 5
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
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        return button
    }()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    // MARK: - Setup viewModel
    
    
    private func setupViewModel() {
            viewModel = RegisterViewModel()
            viewModel.delegate = self
        }
    
    // MARK: - Setup UI
    
    private func setupUI(){
        //View properties
        view.backgroundColor = .systemBackground
        title = "Register"
        
        //Add subviews
        addSubviews()
        
        //change profile picture
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        let geasture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        imageView.addGestureRecognizer(geasture)
        
        //Register Button target
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        //TextFields delegates
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        password.delegate = self
        passwordConfirm.delegate = self
        
        //Add frames
        addFrames()
    }
    
    
    private func addSubviews(){
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(password)
        scrollView.addSubview(passwordConfirm)
        scrollView.addSubview(registerButton)
    }
    
    private func addFrames(){
        //scroll view frame and size
        scrollView.frame = view.bounds
        
        //subViews frame
        let size = scrollView.width/2
        imageView.frame = CGRect(x: (scrollView.width-size)/2, y: 30, width: size, height: size)
        imageView.layer.cornerRadius = size/2
        firstNameField.frame = CGRect(x: 20, y: Int(imageView.bottom) + 50, width: Int(scrollView.width) - 40, height: 50)
        lastNameField.frame = CGRect(x: 20, y: Int(firstNameField.bottom) + 10, width: Int(scrollView.width) - 40, height: 50)
        emailField.frame = CGRect(x: 20, y: Int(lastNameField.bottom) + 10, width: Int(scrollView.width) - 40, height: 50)
        password.frame = CGRect(x: 20, y: emailField.bottom + 10, width: scrollView.width - 40, height: 50)
        passwordConfirm.frame = CGRect(x: 20, y: password.bottom + 10, width: scrollView.width - 40, height: 50)
        registerButton.frame = CGRect(x: 20, y: Int(passwordConfirm.bottom) + 50, width: Int(scrollView.width) - 40, height: 45)
        
        let scrollViewHeight = imageView.height + emailField.height + password.height + firstNameField.height + lastNameField.height + passwordConfirm.height + registerButton.height + 200
        
        print(scrollViewHeight)
        scrollView.contentSize = CGSize(width: view.width, height: scrollViewHeight)
    }
    
    // MARK: - Target functions
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
              !password.isEmpty
            else {
            alertUserLogInError(message: "Please fill all data")
            return
        }
        guard passwordConfirm == password else {
            alertUserLogInError(message: "Please enter your password again in password confirm field.")
            return
        }
        spinner.show(in: view)
        viewModel.registerUser(firstName: firstName, lastName: lastName, email: email, password: password,spinner: spinner)
    }
    
    
    //Change profile pic
    @objc private func didTapChangeProfilePic(){
        presentPhotoActionSheet()
    }

    
    
    // MARK: - Alert function
    func alertUserLogInError(message:String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        present(alert,animated: true)
    }
}


// MARK: - TextField delegate
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

// MARK: - Image picker delegate

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


// MARK: - Register viewModel delegate
extension RegisterViewController: RegisterViewModelDelegate {
    func registrationSuccess() {
        navigationController?.dismiss(animated: true)
    }

    func registrationFailure(error: Error) {
        let errorMessage = "An error occurred during registration: \(error.localizedDescription)"
        alertUserLogInError(message: errorMessage)
    }
}
