//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 08..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            photoImageView.image = selectedImage
        }
    }
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .orange
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        return iv
    }()
    
    let captionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .lightGray
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setuSubViews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    }
    
    @objc func handleShare() {
        print("shaer")
    }
    
    func setuSubViews() {
        let headerView = UIView()
        headerView.backgroundColor = .cyan
        headerView.translatesAutoresizingMaskIntoConstraints = false
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
