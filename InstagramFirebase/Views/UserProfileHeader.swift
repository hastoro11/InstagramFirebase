//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 06..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionReusableView {
    
    //MARK: - outlets
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
            profileImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var usernameLabel: UILabel! {
        didSet {
            usernameLabel.text = ""
        }
    }
    @IBOutlet weak var postsLabel: UILabel! {
        didSet {
            postsLabel.text = ""
        }
    }
    @IBOutlet weak var followersLabel: UILabel! {
        didSet {
            followersLabel.text = ""
        }
    }
    @IBOutlet weak var followingLabel: UILabel! {
        didSet {
            followingLabel.text = ""
        }
    }
    @IBOutlet weak var editProfileButton: UIButton! {
        didSet {
            editProfileButton.setTitle("", for: .normal)
        }
    }
    
    //MARK: - vars
    var user: User?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - funcs
    func configure() {
        loadProfileImage()
        configureLabels()
        configureButton()
    }
    
    fileprivate func configureButton() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        if userId == currentUserId {
            editProfileButton.setTitle("Edit Profile", for: .normal)
            editProfileButton.backgroundColor = .white
            editProfileButton.setTitleColor(.black, for: .normal)
            editProfileButton.addTarget(self, action: #selector(editProfileHandler), for: .touchUpInside)
        } else {
            Firestore.isUserFollowed(userId: userId) { (result) in
                if result {
                    self.configureUnFollowButton()
                } else {
                    self.configureFollowButton()
                }
            }            
        }
        editProfileButton.layer.cornerRadius = 5
        editProfileButton.layer.masksToBounds = true
        editProfileButton.layer.borderColor = UIColor.lightGray.cgColor
        editProfileButton.layer.borderWidth = 0.5
    }
    
    fileprivate func configureFollowButton() {
        editProfileButton.setTitle("Follow", for: .normal)
        editProfileButton.backgroundColor = kLOGINBUTTON_COLOR
        editProfileButton.setTitleColor(.white, for: .normal)
        editProfileButton.addTarget(self, action: #selector(followHandler), for: .touchUpInside)
    }
    
    fileprivate func configureUnFollowButton() {
        editProfileButton.setTitle("Unfollow", for: .normal)
        editProfileButton.backgroundColor = .white
        editProfileButton.setTitleColor(.black, for: .normal)
        editProfileButton.addTarget(self, action: #selector(unFollowHandler), for: .touchUpInside)
    }
    
    @objc func editProfileHandler() {
        print("edit profile")
    }
    
    @objc func followHandler() {
        guard let user = user else {return}
        Firestore.followUser(userId: user.uid) { (_) in
            self.configureUnFollowButton()
        }
    }
    
    @objc func unFollowHandler() {
        guard let user = user else {return}
        Firestore.unFollowUser(userId: user.uid) { (_) in
            self.configureFollowButton()
        }
    }
    
    fileprivate func configureLabels() {
        guard let user = user else {return}
        usernameLabel.text = user.username
        let postAttributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        postAttributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        postsLabel.attributedText = postAttributedText
        let followerstAttributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        followerstAttributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        followersLabel.attributedText = followerstAttributedText
        let followingAttributedText = NSMutableAttributedString(string: "1\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        followingAttributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        followingLabel.attributedText = followingAttributedText
    }
    
    fileprivate func loadProfileImage() {
        guard let user = user else { return }        
        profileImageView.loadImage(from: user.profileImageURL)
    }
}
