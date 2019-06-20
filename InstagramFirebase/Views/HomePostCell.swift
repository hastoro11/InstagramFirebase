//
//  HomeCell.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 09..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate {
    func commentButtonDidTap(post: Post)
    func likeButtonDidTap(for cell: HomePostCell)
}

class HomePostCell: UICollectionViewCell {
    var delegate: HomePostCellDelegate?
    
    var post: Post? {
        didSet {
            guard let post = post else {return}
            imageView.loadImage(from: post.imageURL)
            usernameLabel.text = post.user.username
            profileImageView.loadImage(from: post.user.profileImageURL)
            
            configureDisplayLabel()
            configureLikeButton()
        }
    }
    
    var profileImageView: UIImageView! = {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var usernameLabel: UILabel! = {
       let lbl = UILabel()
        lbl.text = "username"
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var optionsButton: UIButton! = {
       let btn = UIButton(type: .system)
        btn.setTitle("•••", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .black
        return btn
    }()
    
    lazy var likeButton: UIButton = {
       let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "like_unselected"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return btn
    }()
    
    func configureLikeButton() {
        guard let post = post else {return}
        likeButton.setImage(post.isLiked ? UIImage(named: "like_selected") : UIImage(named: "like_unselected"), for: .normal)
    }
    
    lazy var commentButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "comment"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return btn
    }()
    
    var sendMessageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "send2"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var favButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var displayLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    fileprivate func setupViews() {
        addSubview(imageView)
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(optionsButton)
        addSubview(displayLabel)
        
        imageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.layer.cornerRadius = 40 / 2
        profileImageView.clipsToBounds = true
        
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        usernameLabel.sizeToFit()
        
        optionsButton.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
        optionsButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        optionsButton.sizeToFit()
        
        setupActionButtons()
        
        displayLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 8).isActive = true
        displayLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        displayLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        displayLabel.sizeToFit()
        
    }
    
    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.tintColor = .black
        addSubview(stackView)
        addSubview(favButton)
        stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        favButton.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        favButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        favButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        favButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    fileprivate func configureDisplayLabel() {
        guard let post = post else {return}
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSAttributedString(string: "1 day before", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        displayLabel.attributedText = attributedText
    }
    
    @objc func handleCommentTapped() {
        guard let post = post else {return}
        delegate?.commentButtonDidTap(post: post)
    }
    
    @objc func handleLikeTapped() {
        delegate?.likeButtonDidTap(for: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
