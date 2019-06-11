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
    
    static func fetchUsers(completion: @escaping ([User]) -> Void) {
        Firestore.firestore().collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching users:", error.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else {return}
            var users = documents.map({ (doc) -> User in
                return User(of: doc.documentID, from: doc.data())
            })
            users.sort(by: { (lh, rh) -> Bool in
                return lh.username.lowercased() < rh.username.lowercased()
            })
            completion(users)
        }
    }
    
    static func followUser(userId: String, completion: @escaping(Bool) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore()
            .collection("following").document(currentUserId)
            .collection("following").document(userId).setData([userId : 1], completion: { (error) in
            if let error = error {
                print("Error setting following:", error.localizedDescription)
                return
            }
            completion(true)
        })
    }
    
    static func unFollowUser(userId: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore()
            .collection("following").document(currentUserId)
            .collection("following").document(userId).delete(completion: { (error) in
            if let error = error {
                print("Error setting unfollowing:", error.localizedDescription)
                return
            }
            completion(true)
        })
    }
    
    static func isUserFollowed(userId: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore()
            .collection("following").document(currentUserId)
            .collection("following").document(userId).getDocument { (result, error) in
                if let error = error {
                    print("Error requesting following:", error.localizedDescription)
                    return
                }
                guard let result = result else {return}
                completion(result.exists)
        }
        
    }
}


