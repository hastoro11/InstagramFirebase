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
    
    //MARK: - vars
    var posts = [Post]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: kNEW_POST_NOTIFICATION, object: nil)
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        fetchPosts()
    }
    
    //MARK: - CollectionView
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
    
    //MARK: - funcs
    @objc func refresh() {
        fetchPosts()
    }
    
    @objc func handleNotification() {
        fetchPosts()
    }
    
    fileprivate func fetchPosts() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        posts = []
        Firestore.fetchFollowing { (fetchedUserIds) in
            var userIds = fetchedUserIds
            userIds.append(currentUserId)
            userIds.forEach({ (userId) in
                Firestore.fetchUserWithUID(uid: userId) { (user) in
                    Firestore.fetchPostsByUser(user: user
                        , completion: { (posts) in
                            self.posts += posts
                            self.posts.sort(by: { $0.creationDate > $1.creationDate})
                            self.collectionView.refreshControl?.endRefreshing()
                            self.collectionView.reloadData()
                    })
                }
            })
        }
        
    }
}
