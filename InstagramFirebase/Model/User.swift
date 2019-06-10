//
//  User.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 06..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import Foundation

struct User {
    var uid: String
    var username: String
    var profileImageURL: String
    
    init(of uid: String, from dictionary: [String: Any]) {
        self.uid = uid
        username = dictionary["username"] as? String ?? ""
        profileImageURL = dictionary["profileImageURL"] as? String ?? ""
    }
}
