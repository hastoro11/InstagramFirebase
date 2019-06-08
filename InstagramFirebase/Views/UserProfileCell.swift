//
//  UserProfileCell.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 08..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit

class UserProfileCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            loadImage()
        }
    }
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
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
        super.init(coder: aDecoder)
    }
    
    fileprivate func loadImage() {
        guard let post = post, let url = URL(string: post.imageURL) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
