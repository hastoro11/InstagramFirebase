//
//  SearchController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 10..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit

private let reuseIdentifier = "datacell"

class SearchController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
        
        return cell
    }
    
    
}
