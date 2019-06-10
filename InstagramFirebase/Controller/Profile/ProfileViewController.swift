//
//  ProfileViewController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 05..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "datacell"
private let reuseHeaderIdentifier = "header"

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - vars
    var user: User?
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        // Register cell classes
        self.collectionView!.register(UserProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(UINib(nibName: "UserProfileHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear"), style: .plain, target: self, action: #selector(logoutButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
        fetchUser()
        fetchPosts()
    }
    
    @objc func logoutButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController")
                self.view.window?.rootViewController = UINavigationController(rootViewController: loginController)
            } catch {
                print("Error logging out:", error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    //MARK: - CollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserProfileCell
        cell.post = posts[indexPath.item]
        
//        cell.identifier = posts[indexPath.item].imageURL
        // Configure the cell
        cell.configure()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! UserProfileHeader
        header.user = user
        header.configure()
        return header
    }
    
    //MARK: - fucns
    fileprivate func fetchUser() {
        let currentUser = Auth.auth().currentUser
        guard let uid = currentUser?.uid else {return}
        Firestore.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = user.username
            self.collectionView.reloadData()
        }        
    }
    
    func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.fetchUserWithUID(uid: uid) { (user) in
            Firestore.fetchPostsByUser(user: user
                , completion: { (posts) in
                    self.posts = posts
                    self.collectionView.reloadData()
            })
        }        
    }
}
