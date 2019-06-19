//
//  CommentCell.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 19..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else {return}
            guard let user = comment.user else {return}
            let attributedText = NSMutableAttributedString(string: user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " \(comment.text)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            commentLabel.attributedText = attributedText
            profileImageView.loadImage(from: user.profileImageURL)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var commentLabel: UITextView = {
        let lbl = UITextView()
        lbl.isEditable = false
        lbl.isScrollEnabled = false
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        iv.backgroundColor = .red
        return iv
    }()
    
    func setupViews() {
        addSubview(commentLabel)
        addSubview(profileImageView)
        commentLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        commentLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true

        
        profileImageView.layer.cornerRadius = 40 / 2
    }
}
