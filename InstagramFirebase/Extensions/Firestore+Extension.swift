//
//  Firestore+Extension.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 10..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import Foundation
import Firebase

extension Firestore {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> Void) {
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetching user:", error.localizedDescription)
                return
            }
            guard let dictionary = snapshot?.data() else {return}
            let user = User(of: uid, from: dictionary)
            completion(user)
        }
    }
    
    static func fetchPostsByUser(user: User, completion: @escaping([Post]) ->Void) {
        Firestore.firestore().collection("posts").document(user.uid).collection("user_posts").order(by: "creationDate", descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching posts:", error.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else {return}
            let posts = documents.map({ (doc) -> Post in
                return Post(user: user, from: doc.data())
            })
            completion(posts)
        }
    }
}


