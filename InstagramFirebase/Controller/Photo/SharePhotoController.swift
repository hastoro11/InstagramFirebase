//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 08..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            photoImageView.image = selectedImage
        }
    }
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        return iv
    }()
    
    let captionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 17)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9086388946, green: 0.9097819328, blue: 0.9098058939, alpha: 1)
        setuSubViews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    }
    
    @objc func handleShare() {
        guard let currentUser = Auth.auth().currentUser else {return}
        guard let caption = captionTextView.text, !caption.isEmpty else {return}
        navigationItem.rightBarButtonItem?.isEnabled = false
        let postImageRef = Storage.storage().reference().child("post_images")
        let filename = UUID().uuidString
        guard let data = selectedImage?.jpegData(compressionQuality: 0.3) else {return}
        postImageRef.child(filename).putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Error uploading image:", error.localizedDescription)
                return
            }
            postImageRef.child(filename).downloadURL(completion: { (url, error) in
                if let error = error {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Error downloading fileurl:", error.localizedDescription)
                    return
                }
                guard let url = url else {return}
                let newPostRef = Firestore.firestore().collection("posts").document(currentUser.uid).collection("user_posts").document()
                let dictionary = ["cpation": caption, "imageURL": url.absoluteString, "creationDate": Date().timeIntervalSince1970] as [String: Any]
                
                newPostRef.setData(dictionary, completion: { (error) in
                    if let error = error {
                        print("Error saving post:", error.localizedDescription)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                })
                
            })
        }
    }
    
    func setuSubViews() {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .white
        view.addSubview(headerView)
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        headerView.addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 8).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: 84).isActive = true
        
        headerView.addSubview(captionTextView)
        captionTextView.topAnchor.constraint(equalTo: photoImageView.topAnchor).isActive = true
        captionTextView.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor).isActive = true
        captionTextView.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 8).isActive = true
        captionTextView.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -8).isActive = true
        
    }
}
