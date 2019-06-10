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
    var creationDate: Date
    var user: User
    var caption: String
    
    init(user: User, from dictionary: [String: Any]) {
        self.user = user
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        if let timeStamp = dictionary["creationDate"] as? Double {
            self.creationDate = Date(timeIntervalSince1970: timeStamp)
        } else {
            self.creationDate = Date()
        }
    }
}
