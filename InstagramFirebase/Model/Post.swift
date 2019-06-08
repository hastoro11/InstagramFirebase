//
//  Post.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 08..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import Foundation

struct Post {
    var imageURL: String
    
    init(from dictionary: [String: Any]) {
        if let imageURL = dictionary["imageURL"] as? String {
            self.imageURL = imageURL
        } else {
            self.imageURL = ""
        }
    }
}
