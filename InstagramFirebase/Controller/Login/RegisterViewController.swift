//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 03..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.addTarget(self, action: #selector(handleTextFields), for: .editingChanged)
        }
    }
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.addTarget(self, action: #selector(handleTextFields), for: .editingChanged)
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.addTarget(self, action: #selector(handleTextFields), for: .editingChanged)
        }
    }
    @IBOutlet weak var signupButton: UIButton! {
        didSet {
            signupButton.isEnabled = false
            signupButton.backgroundColor = kLOGINBUTTON_COLOR_DISABLED
        }
    }
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var alreadyHaveAnAccount: UIButton! {
        didSet {
            let attributedText = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            attributedText.append(NSAttributedString(string: "Sign in", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white]))
            alreadyHaveAnAccount.setAttributedTitle(attributedText, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addPhotoButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func alreadyHaveAnAccountButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTextFields() {
        if let email = emailTextField.text, !email.isEmpty,
            let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty {
            signupButton.isEnabled = true
            signupButton.backgroundColor = kLOGINBUTTON_COLOR
        } else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = kLOGINBUTTON_COLOR_DISABLED
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("original")
            addPhotoButton.setImage(originalImage, for: .normal)
        } else if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            addPhotoButton.setImage(editedImage, for: .normal)
        }
        addPhotoButton.layer.cornerRadius = addPhotoButton.bounds.width / 2
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.layer.borderColor = UIColor.black.cgColor
        addPhotoButton.layer.borderWidth = 1.5
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func signUpButtonTapped() {
        guard let email = emailTextField.text else {return}
        guard let username = usernameTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        let profileImagesRef = Storage.storage().reference().child("profile_images")
        let fileName = UUID().uuidString
        guard let uploadData = addPhotoButton.image(for: .normal)?.jpegData(compressionQuality: 0.3) else {return}
        profileImagesRef.child(fileName).putData(uploadData, metadata: nil) { (metaData, error) in
            if let error = error {
                print("Error uploading file:", error.localizedDescription)
                return
            }
            profileImagesRef.child(fileName).downloadURL(completion: { (url, error) in
                if let error = error {
                    print("Error in url:", error.localizedDescription)
                    return
                }
                Auth.auth().createUser(withEmail: email, password: password, completion: { (firUser, error) in
                    if let error = error {
                        print("Error inregistering user:", error.localizedDescription)
                        return
                    }
                    guard let url = url else {return}
                    if let user = firUser?.user {
                        let dictionary = ["username": username, "email": email, "profileImageURL": url.absoluteString]
                        Firestore.firestore().collection("users").document(user.uid).setData(dictionary
                            , completion: { (error) in
                                if let error = error {
                                    print("Error in saving user:", error.localizedDescription)
                                    return
                                }
                                let mainController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController")
                                self.view.window?.rootViewController = mainController
                        })
                    }
                })
            })
            
        }
        
    }

}

