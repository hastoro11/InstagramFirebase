//
//  SearchCell.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 10..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    var user: User? {
        didSet {
            guard let user = user else {return}
            profileImageView.loadImage(from: user.profileImageURL)
            usernameLabel.text = user.username
        }
    }
    
    var profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .orange
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var usernameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "username"
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        profileImageView.layer.cornerRadius = 40 / 2
        
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorView.backgroundColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
