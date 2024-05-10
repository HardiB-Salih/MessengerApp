//
//  RegisterViewController.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/7/24.
//

import UIKit
import PhotosUI
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)

    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let  activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemGray
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.cornerCurve = .continuous
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.3).cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let firstNameField : UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.cornerCurve = .continuous
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.3).cgColor
        textField.placeholder = "First Name..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.1)
        return textField
    }()
    
    private let lastNameField : UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.cornerCurve = .continuous
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.3).cgColor
        textField.placeholder = "Last Name..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.1)
        return textField
    }()
    
    private let emailField : UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.cornerCurve = .continuous
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.3).cgColor
        textField.placeholder = "Email Address..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.1)
        return textField
    }()
    
    private let passwordField : UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.layer.cornerCurve = .continuous
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.3).cgColor
        textField.placeholder = "Password..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.1)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let rigesterButon : UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .link
        button.layer.cornerRadius = 12
        button.layer.cornerCurve = .continuous
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create Account"
        view.backgroundColor = .systemBackground
        
        setUpSelecters()
        setUpTextField()
        setUpSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imageView.frame = CGRect(x: (scrollView.width - size) / 2, y: 20, width: size, height: size)
        activityIndicator.frame = CGRect(x: imageView.bounds.midX - 15, y: imageView.bounds.midX - 15 , width: 30, height: 30)
        firstNameField.frame = CGRect(x: 30, y: imageView.bottom + 30, width: scrollView.width - 60, height: 44)
        lastNameField.frame = CGRect(x: 30, y: firstNameField.bottom + 10, width: scrollView.width - 60, height: 44)
        emailField.frame = CGRect(x: 30, y: lastNameField.bottom + 10, width: scrollView.width - 60, height: 44)
        passwordField.frame = CGRect(x: 30, y: emailField.bottom + 10, width: scrollView.width - 60, height: 44)
        rigesterButon.frame = CGRect(x: 30, y: passwordField.bottom + 20, width: scrollView.width - 60, height: 44)
        
    }
    
    
    //MARK: -Private
    private func setUpSelecters() {
        
        // Add tap gesture recognizer
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        
        rigesterButon.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    private func setUpTextField() {
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    private func setUpSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        imageView.addSubview(activityIndicator)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(rigesterButon)
    }
    
    /// Save the updated value of logged_in to UserDefaults
    private func userLoggedIn(){
//        UserDefaults.standard.set(true, forKey: "logged_in")
        NotificationCenter.default.post(name: UserDefaults.didChangeNotification, object: nil)
    }
    
    //MARK: -OBJC Functions
    @objc private func registerButtonTapped() {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let firstname = firstNameField.text,
              let lastname = lastNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              firstname.isNotEmpty, lastname.isNotEmpty,
              email.isNotEmpty, password.isNotEmpty,
              password.count >= 6 else {
            self.showAlert(title: "Woops",
                           message: "please enter all information to create a new account")
            return
        }
        
        
        
        spinner.show(in: view)
        
        
        DatabaseManager.userExists(with: email) {[weak self] isExist in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard !isExist else {
                strongSelf.showAlert(title: "Opps", message: "userAlready Exist")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email,
                                                password: password,
                                                completion: { authResult, error in
                guard authResult != nil, error == nil else {
                    strongSelf.showAlert(title: "Create Account Error", message: "User did not create becase of \(error?.localizedDescription ?? "")")
                    return
                }
                
                let chatAppUser = ChatAppUser(firstName: firstname,
                                              lastname: lastname,
                                              emailAddress: email)
                
                DatabaseManager.insertUser(with: chatAppUser, completion: { success in
                    if success {
                        // Upload Image
                        guard let image = strongSelf.imageView.image,
                              let data = image.pngData() else {
                            return
                        }
                        
                        /*
                         /images/hardi-gmail-com_profile_picture.png
                         */
                        let fileName = chatAppUser.profilePictureFileName
                        StorageManager.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                            switch result {
                            case .success(let downloadUrl):
                                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
//                                print(downloadUrl)
                            case .failure(let error):
                                print("Storage Manager Error: \(error.localizedDescription)")
                            }
                        })
                        UserDefaults.standard.set(email, forKey: "email")
                        strongSelf.userLoggedIn()
                    }
                })
                
            })
        }
    }
    
    @objc private func handleImageViewTap() {
        //        userLoggedIn()
        presentPhotoActionSheet()
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case firstNameField:
            lastNameField.becomeFirstResponder()
        case lastNameField:
            emailField.becomeFirstResponder()
        case emailField:
            passwordField.becomeFirstResponder()
        case passwordField:
            registerButtonTapped()
        default:
            registerButtonTapped()
        }
        return true
    }
}

//MARK: - Selecting and taking photo
extension RegisterViewController: UIImagePickerControllerDelegate, PHPickerViewControllerDelegate, UINavigationControllerDelegate{

    
    private func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would your like to select a picture?",
                                            preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        let takePhotoButton = UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler:  { [weak self] _ in  self?.presentCamera() })
        let chosePhotoButton = UIAlertAction(title: "Chose Photo",
                                             style: .default,
                                             handler:  { [weak self] _ in  self?.presentPhotoPicker() })
        
        actionSheet.addAction(cancelButton)
        actionSheet.addAction(takePhotoButton)
        actionSheet.addAction(chosePhotoButton)
        
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera(){ 
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "Camera error",
                      message: "Check your mobile camera not working.")
            return
        }
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func presentPhotoPicker(){
        let picker = PHPickerViewController(configuration: PHPickerConfiguration())
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            imageView.image = image
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        
        for result in results {
            activityIndicator.startAnimating()
            // Process the selected item
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    guard let image = image as? UIImage else { return }
                    // Do something with the selected image
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { 
        dismiss(animated: true, completion: nil)
    }
    
}
