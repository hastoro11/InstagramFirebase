//
//  ProfileViewController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 05..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "gridcell"
private let reuseHeaderIdentifier = "header"
private let listReuseIdentifier = "listcell"

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    //MARK: - vars
    var user: User?
    var posts = [Post]()
    var userId: String?
    var isGrid = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: kNEW_POST_NOTIFICATION, object: nil)
        collectionView.backgroundColor = .white
        // Register cell classes
        self.collectionView!.register(UserProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: listReuseIdentifier)
        self.collectionView.register(UINib(nibName: "UserProfileHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear"), style: .plain, target: self, action: #selector(logoutButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
        fetchUser()
//        fetchPosts()
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
        if isGrid {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserProfileCell
            cell.post = posts[indexPath.item]
            
            //        cell.identifier = posts[indexPath.item].imageURL
            // Configure the cell
            cell.configure()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listReuseIdentifier, for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGrid {
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        } else {
            var height = view.frame.width
            height += 8 + 40 + 8
            height += 50
            height += 80
            return CGSize(width: view.frame.width, height: height)
        }
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
        header.delegate = self
        header.configure()
        return header
    }
    
    //MARK: - fucns
    @objc func handleNotification() {
        fetchPosts()
    }
    
    fileprivate func fetchUser() {
        let currentUser = Auth.auth().currentUser
        let uid = userId ?? currentUser?.uid ?? ""
        Firestore.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = user.username
            Firestore.fetchUserWithUID(uid: uid) { (user) in
                Firestore.fetchPostsByUser(user: user
                    , completion: { (posts) in
                        self.posts = posts
                        self.collectionView.reloadData()
                })
            }
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
    
    func gridViewButtonDidTap() {
        isGrid = true
        collectionView.reloadData()
    }
    
    func listViewButtonDidTap() {
        isGrid = false
        collectionView.reloadData()
    }
}
