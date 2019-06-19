//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 19..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit

struct Comment {
    var user: User?
    var userId: String
    var text: String
    var creationDate: Date
    
    init(from dictionary: [String: Any]) {
        self.userId = dictionary["uid"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        let timeInterval = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: timeInterval)
    }
}
