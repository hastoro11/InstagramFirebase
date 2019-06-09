//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 06..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit

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
        editProfileButton.setTitle("Edit Profile", for: .normal)
        editProfileButton.layer.cornerRadius = 5
        editProfileButton.layer.masksToBounds = true
        editProfileButton.layer.borderColor = UIColor.lightGray.cgColor
        editProfileButton.layer.borderWidth = 0.5
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
