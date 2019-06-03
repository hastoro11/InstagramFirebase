//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 03..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signUpButtonTapped() {
        let email = "dummy5@mail.com"
        let username = "dummy5"
        let password = "123456"
        
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (firUser, error) in
            if let error = error {
                print("Error in register user:", error.localizedDescription)
                return
            }
            if let user = firUser?.user {
                let dictionary = ["username": username, "email": email]
//                Firestore.firestore().collection("users").addDocument(data: dictionary, completion: { (error) in
//                    if let error = error {
//                        print("Error in saving user:", error.localizedDescription)
//                        return
//                    }
//                })
                Firestore.firestore().collection("users").document(user.uid).setData(dictionary, completion: { (error) in
                    if let error = error {
                        print("Error in saving user:", error.localizedDescription)
                        return
                    }
                })
            }
        }
        
    }

}

