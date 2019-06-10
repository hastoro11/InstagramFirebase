//
//  SearchController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 10..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "datacell"

class SearchController: UITableViewController, UISearchResultsUpdating {
    
    var searcController = UISearchController(searchResultsController: nil)
    var users = [User]()
    var filteredUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        searcController.searchResultsUpdater = self
        navigationItem.searchController = searcController
        searcController.searchBar.tintColor = .black
        fetchUsers()
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
        cell.user = filteredUsers[indexPath.row]
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter({ (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            })
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func fetchUsers() {
        Firestore.fetchUsers { (users) in
            self.users = users
            self.filteredUsers = users
            self.tableView.reloadData()
        }
    }
}
