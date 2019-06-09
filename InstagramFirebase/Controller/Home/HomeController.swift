//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 09..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "datacell"

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
        fetchPosts()
    }
    
    var posts = [Post]()
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = view.frame.width
        height += 8 + 40 + 8
        height += 50
        height += 80
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    fileprivate func fetchPosts() {
        guard let user = Auth.auth().currentUser else {return}
        let postsRef = Firestore.firestore().collection("posts").document(user.uid).collection("user_posts")
        postsRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching posts:", error.localizedDescription)
                return
            }
            guard let postsArray = snapshot.map({$0.documents.map({$0.data()})}) else {return}
            postsArray.forEach({ (dictionary) in
                self.posts.append(Post(from: dictionary))
            })
            self.collectionView.reloadData()
        }
    }
}
