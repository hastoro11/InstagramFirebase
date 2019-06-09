//
//  HomeCell.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 09..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let url = post?.imageURL else {return}
            imageView.loadImage(from: url)
        }
    }
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
