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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3"
        ), style: .plain, target: self, action: #selector(handlePhotoButton))
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
        cell.delegate = self
        if indexPath.item < posts.count {
            cell.post = posts[indexPath.item]
        }
        return cell
    }
    
    //MARK: - funcs
    @objc func handlePhotoButton() {
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
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
                            posts.forEach({ (post) in
                                Firestore.firestore().collection("likes").document(post.uid!).collection("likes").document(user.uid).getDocument(completion: { (snapshot, error) in
                                    if let likedDict = snapshot?.data(), let isLiked = likedDict[user.uid] as? Int {
                                        post.isLiked = isLiked == 1 ? true : false
                                    }
                                    self.collectionView.reloadData()
                                })
                                
                                
                            })
                            
                    })
                }
            })
        }
        
    }
}

extension HomeController: HomePostCellDelegate {
    func commentButtonDidTap(post: Post) {
        let commentController = CommentController()
        commentController.post = post
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(commentController, animated: true)
    }
    
    func likeButtonDidTap(for cell: HomePostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        guard let userId = Auth.auth().currentUser?.uid else {return}
        var post = posts[indexPath.item]
        guard let postId = post.uid else {return}
        
        Firestore.likePostByUser(userId: userId, postId: postId, isLiked: post.isLiked) { (_) in
            post.isLiked = !post.isLiked
            self.posts[indexPath.item] = post
            self.collectionView.reloadData()
        }
        
    }
}
