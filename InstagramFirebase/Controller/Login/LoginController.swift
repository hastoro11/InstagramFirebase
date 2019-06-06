//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 06..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.addTarget(self, action: #selector(handleTextFields), for: .editingChanged)
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.addTarget(self, action: #selector(handleTextFields), for: .editingChanged)
        }
    }
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.isEnabled = false
            signInButton.backgroundColor = kLOGINBUTTON_COLOR_DISABLED
        }
    }
    @IBOutlet weak var dontHaveAnAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "Sign up", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white]))
        dontHaveAnAccountButton.setAttributedTitle(attributedText, for: .normal)
        
        self.navigationController?.isNavigationBarHidden = true

    }
    
    @IBAction func dontHaveAccountButtonTapped() {
        let registerController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController")
        navigationController?.pushViewController(registerController, animated: true)
    }
    
    @IBAction func signinButtonTapped() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error signing in:", error.localizedDescription)
                return
            }
            let mainController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController")
            self.view.window?.rootViewController = mainController
            
        }
    }
    
    @objc func handleTextFields() {
        if let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty {
            signInButton.isEnabled = true
            signInButton.backgroundColor = kLOGINBUTTON_COLOR
        } else {
            signInButton.isEnabled = false
            signInButton.backgroundColor = kLOGINBUTTON_COLOR_DISABLED
        }
    }
}
