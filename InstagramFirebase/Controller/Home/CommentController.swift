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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.tintColor = .black
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
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "Text"
        return cell
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return containerView
    }
}
