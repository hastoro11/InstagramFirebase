//
//  CommentController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 18..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "datacell"

class CommentController: UITableViewController, UITextFieldDelegate {
    var post: Post?    
    var comments = [Comment]()
    
    var commentTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter comment"
        return tf
    }()
    
    lazy var containerView: UIView = {
        let iv = UIView()
        iv.frame = CGRect(x: 0, y: 0, width: 100, height: 75)
        
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setAttributedTitle(NSAttributedString(string: "Send", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black]), for: .normal)
        btn.addTarget(self, action: #selector(handleSendComment), for: .touchUpInside)
        
        iv.addSubview(commentTextField)
        iv.addSubview(btn)
        
        commentTextField.topAnchor.constraint(equalTo: iv.topAnchor).isActive = true
        commentTextField.rightAnchor.constraint(equalTo: btn.leftAnchor).isActive = true
        commentTextField.bottomAnchor.constraint(equalTo: iv.bottomAnchor, constant: -12).isActive = true
        commentTextField.leftAnchor.constraint(equalTo: iv.leftAnchor, constant: 12).isActive = true
        btn.topAnchor.constraint(equalTo: iv.topAnchor).isActive = true
        btn.rightAnchor.constraint(equalTo: iv.rightAnchor).isActive = true
        btn.bottomAnchor.constraint(equalTo: iv.bottomAnchor, constant: -12).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CommentCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 300
        navigationController?.navigationBar.tintColor = .black
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func handleSendComment() {
        guard let text = commentTextField.text, !text.isEmpty else {return}
        guard let postId = post?.uid else {return}
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        Firestore.insertComment(postId: postId, userId: userId, text: text) { (_) in
            self.commentTextField.resignFirstResponder()
            self.commentTextField.text = ""
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        let cell = CommentCell(frame: frame)
        cell.comment = comments[indexPath.row]
        
        let size = cell.commentLabel.sizeThatFits(frame.size)
        
        let height = max(40 + 8 + 8, size.height + 8 + 20)
        return height
    }
    
    func fetchComments() {
        guard let postId = post?.uid else {return}
        Firestore.fetchCommentsForPostId(postId: postId) { (comments) in
            comments.forEach({ (comment) in
                Firestore.fetchUserWithUID(uid: comment.userId, completion: { (user) in
                    var newComment = comment
                    newComment.user = user
                    self.comments.append(newComment)
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return containerView
    }
}
